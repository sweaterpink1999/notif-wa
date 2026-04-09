cat > $HOME/bot-wa.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

TOKEN="8290196740:AAGAMlvolfPinlOIQMkrgsB1kgOjtSBU0zc"
CHAT_ID="1386780002"
FONNTE="odCdkwttceRZM4VdaPti"

DATA="$HOME/datauser.txt"
STATE="$HOME/state.txt"

touch $DATA
touch $STATE

send_tg() {
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
-d chat_id="$CHAT_ID" \
-d text="$1" > /dev/null
}

send_menu() {
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
-d chat_id="$CHAT_ID" \
-d text="🤖 MENU BOT

➕ Tambah
📋 List
📤 Kirim
❌ Hapus" \
-d reply_markup='{
  "keyboard":[
    ["➕ Tambah","📋 List"],
    ["📤 Kirim","❌ Hapus"]
  ],
  "resize_keyboard":true
}' > /dev/null
}

send_wa() {
curl -s -X POST "https://api.fonnte.com/send" \
-H "Authorization: $FONNTE" \
-d "target=$1" \
-d "message=$2" > /dev/null
}

set_state() {
echo "$1" > $STATE
}

get_state() {
cat $STATE
}

handle_command() {
msg="$1"
state=$(get_state)

[[ -z "$msg" ]] && return

# START
if [[ "$msg" == "/start" ]]; then
  send_menu
  set_state "idle"
  return
fi

# ================= TAMBAH INTERAKTIF =================

if [[ "$msg" == "➕ Tambah" ]]; then
  send_tg "Masukkan nama:"
  set_state "tambah_nama"
  return
fi

if [[ "$state" == "tambah_nama" ]]; then
  echo "$msg" > $HOME/tmp_nama
  send_tg "Masukkan nomor (contoh 628xxx):"
  set_state "tambah_nomor"
  return
fi

if [[ "$state" == "tambah_nomor" ]]; then
  echo "$msg" > $HOME/tmp_nomor
  send_tg "Masukkan tanggal expired (YYYY-MM-DD):"
  set_state "tambah_exp"
  return
fi

if [[ "$state" == "tambah_exp" ]]; then
  nama=$(cat $HOME/tmp_nama)
  nomor=$(cat $HOME/tmp_nomor)
  exp="$msg"

  echo "$nama $nomor $exp" >> $DATA
  send_tg "✅ Berhasil ditambahkan:\n$nama ($nomor)\nExp: $exp"

  set_state "idle"
  return
fi

# ================= LIST =================

if [[ "$msg" == "📋 List" ]]; then
  if [[ ! -s $DATA ]]; then
    send_tg "📭 Data kosong"
  else
    no=1
    text="📋 DATA USER:\n"
    while read user wa exp; do
      text+="\n$no. $user\n📱 $wa\n📅 Exp: $exp\n"
      no=$((no+1))
    done < $DATA
    send_tg "$text"
  fi
  return
fi

# ================= KIRIM INTERAKTIF =================

if [[ "$msg" == "📤 Kirim" ]]; then
  send_tg "Masukkan pesan yang ingin dikirim:"
  set_state "kirim_pesan"
  return
fi

if [[ "$state" == "kirim_pesan" ]]; then
  text="$msg"
  jumlah=0

  while read user wa exp; do
    [[ -z "$user" ]] && continue
    send_wa "$wa" "📢 INFO\n$text"
    jumlah=$((jumlah+1))
  done < $DATA

  send_tg "✅ Pesan terkirim ke $jumlah user"
  set_state "idle"
  return
fi

# ================= HAPUS =================

if [[ "$msg" == "❌ Hapus" ]]; then
  send_tg "Masukkan nomor yang mau dihapus:"
  set_state "hapus"
  return
fi

if [[ "$state" == "hapus" ]]; then
  wa="$msg"

  if grep -q "$wa" $DATA; then
    sed -i "/$wa/d" $DATA
    send_tg "❌ Dihapus: $wa"
  else
    send_tg "⚠️ Tidak ditemukan"
  fi

  set_state "idle"
  return
fi

}

# ================= LOOP =================

last_update=0

while true; do
  response=$(curl -s "https://api.telegram.org/bot$TOKEN/getUpdates?offset=$last_update")

  updates=$(echo "$response" | jq -c '.result[]?')

  for update in $updates; do
    update_id=$(echo "$update" | jq '.update_id')
    message=$(echo "$update" | jq -r '.message.text // empty')

    [[ -z "$message" ]] && continue

    if (( update_id >= last_update )); then
      last_update=$((update_id+1))
      handle_command "$message"
    fi
  done

  sleep 2
done
EOF

chmod +x $HOME/bot-wa.sh
