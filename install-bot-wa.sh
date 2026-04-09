#!/data/data/com.termux/files/usr/bin/bash

TOKEN="8290196740:AAGAMlvolfPinlOIQMkrgsB1kgOjtSBU0zc"
CHAT_ID="1386780002"
FONNTE="odCdkwttceRZM4VdaPti"

DATA="$HOME/datauser.txt"
OFFSET_FILE="$HOME/offset.txt"
STATE_FILE="$HOME/state.txt"

send_tg() {
curl -s -X POST https://api.telegram.org/bot$TOKEN/sendMessage \
-d chat_id=$CHAT_ID \
-d text="$1" \
-d reply_markup='{
"keyboard":[
["➕ Tambah","📋 List"],
["📤 Kirim","❌ Hapus"]
],
"resize_keyboard":true
}' > /dev/null
}

send_wa() {
curl -s -X POST https://api.fonnte.com/send \
-H "Authorization: $FONNTE" \
-d "target=$1" \
-d "message=$2" > /dev/null
}

handle() {
msg="$1"
state=$(cat $STATE_FILE 2>/dev/null)

[[ -z "$msg" ]] && return

# ===== START =====
if [[ "$msg" == "/start" ]]; then
send_tg "🤖 BOT AKTIF"
return
fi

# ===== TOMBOL TAMBAH =====
if [[ "$msg" == "➕ Tambah" ]]; then
echo "tambah" > $STATE_FILE
send_tg "Masukkan nomor & tanggal:
628xxx 2026-05-01"
return
fi

# ===== INPUT TAMBAH (FIXED) =====
if [[ "$state" == "tambah" ]]; then
IFS=' ' read nomor exp <<< "$msg"

if [[ -z "$nomor" || -z "$exp" ]]; then
send_tg "Format salah!
Contoh:
628xxx 2026-05-01"
return
fi

echo "$nomor|$exp" >> "$DATA"
echo "" > $STATE_FILE

send_tg "✅ Ditambahkan"
return
fi

# ===== LIST =====
if [[ "$msg" == "📋 List" ]]; then
[[ ! -s "$DATA" ]] && send_tg "Kosong" && return

list=""
while IFS="|" read -r nomor exp; do
list="$list\n$nomor | $exp"
done < "$DATA"

send_tg "$list"
return
fi

# ===== KIRIM =====
if [[ "$msg" == "📤 Kirim" ]]; then
echo "kirim" > $STATE_FILE
send_tg "Masukkan pesan:"
return
fi

if [[ "$state" == "kirim" ]]; then
text="$msg"
today=$(date +%Y-%m-%d)

while IFS="|" read -r nomor exp; do
[[ "$exp" < "$today" ]] && continue
send_wa "$nomor" "$text"
sleep 2
done < "$DATA"

echo "" > $STATE_FILE
send_tg "✅ Pesan terkirim"
return
fi

# ===== HAPUS EXPIRED =====
if [[ "$msg" == "❌ Hapus" ]]; then
today=$(date +%Y-%m-%d)
tmp="$HOME/tmp.txt"
> "$tmp"

while IFS="|" read -r nomor exp; do
[[ "$exp" > "$today" ]] && echo "$nomor|$exp" >> "$tmp"
done < "$DATA"

mv "$tmp" "$DATA"
send_tg "✅ Expired dihapus"
return
fi
}

offset=$(cat $OFFSET_FILE)

while true; do

res=$(curl -s "https://api.telegram.org/bot$TOKEN/getUpdates?offset=$offset")

# ===== FIX JQ ERROR =====
[[ -z "$res" ]] && sleep 2 && continue

echo "$res" | jq . >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
echo "[ERROR] JSON tidak valid"
sleep 2
continue
fi

updates=$(echo "$res" | jq -c '.result[]?')

[[ -z "$updates" ]] && sleep 2 && continue

for u in $updates; do
id=$(echo "$u" | jq '.update_id')
msg=$(echo "$u" | jq -r '.message.text // empty')
from=$(echo "$u" | jq -r '.message.from.id // empty')

[[ "$from" != "$CHAT_ID" ]] && continue
[[ -z "$msg" ]] && continue

offset=$((id+1))
echo $offset > "$OFFSET_FILE"

handle "$msg"
done

sleep 2
done
