

#!/data/data/com.termux/files/usr/bin/bash

clear
echo "================================="
echo " INSTALL BOT WA TERMUX 🔥 FINAL"
echo "================================="

# ====== CONFIG ======
TOKEN="8290196740:AAGAMlvolfPinlOIQMkrgsB1kgOjtSBU0zc"
CHAT_ID="1386780002"
FONNTE="odCdkwttceRZM4VdaPti"

# ====== DEPENDENCY ======
echo "[INFO] Install dependency..."
pkg update -y >/dev/null 2>&1
pkg install -y curl jq tmux >/dev/null 2>&1

# ====== CLEAN ======
rm -f $HOME/offset.txt
rm -f $HOME/datauser.txt
rm -f $HOME/state.txt

# ====== RESET TELEGRAM ======
curl -s "https://api.telegram.org/bot$TOKEN/getUpdates?offset=-1" > /dev/null

# ====== FILE ======
touch $HOME/datauser.txt
echo "0" > $HOME/offset.txt
touch $HOME/state.txt

# ====== BOT ======
cat > $HOME/bot-wa.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

TOKEN="__TOKEN__"
CHAT_ID="__CHAT_ID__"
FONNTE="__FONNTE__"

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
state=$(cat $STATE_FILE)

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

# ===== INPUT TAMBAH =====
if [[ "$state" == "tambah" ]]; then
nomor=$(echo "$msg" | awk '{print $1}')
exp=$(echo "$msg" | awk '{print $2}')

if [[ -z "$nomor" || -z "$exp" ]]; then
send_tg "Format salah!"
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

updates=$(echo "$res" | jq -c '.result[]?')

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
EOF

# inject
sed -i "s|__TOKEN__|$TOKEN|g" $HOME/bot-wa.sh
sed -i "s|__CHAT_ID__|$CHAT_ID|g" $HOME/bot-wa.sh
sed -i "s|__FONNTE__|$FONNTE|g" $HOME/bot-wa.sh

chmod +x $HOME/bot-wa.sh

echo ""
echo "================================="
echo " INSTALL SELESAI ✅"
echo "================================="
echo ""
echo "Jalankan:"
echo "tmux"
echo "while true; do bash ~/bot-wa.sh; sleep 3; done"
