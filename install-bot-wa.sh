cat > $HOME/bot-wa.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

TOKEN="8290196740:AAGAMlvolfPinlOIQMkrgsB1kgOjtSBU0zc"
CHAT_ID="1386780002"
FONNTE="odCdkwttceRZM4VdaPti"

DATA="$HOME/datauser.txt"
STATE="$HOME/state.txt"
OFFSET_FILE="$HOME/offset.txt"

touch $DATA
touch $STATE
touch $OFFSET_FILE

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

set_state() { echo "$1" > $STATE; }
get_state() { cat $STATE; }

# ================= COMMAND =================

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

# TAMBAH
if [[ "$msg" == "➕ Tambah" ]]; then
  send_tg "Masukkan nama:"
  set_state "nama"
  return
fi

if [[ "$state" == "nama" ]]; then
  echo "$msg" > $HOME/nama
  send_tg "Masukkan nomor:"
  set_state "nomor"
  return
fi

if [[ "$state" == "nomor" ]]; then
  echo "$msg" > $HOME/nomor
  send_tg "Masukkan tanggal (YYYY-MM-DD):"
  set_state "exp"
  return
fi

if [[ "$state" == "exp" ]]; then
  nama=$(cat $HOME/nama)
  nomor=$(cat $HOME/nomor)

  echo "$nama $nomor $msg" >> $DATA
  send_tg "✅ Ditambahkan: $nama ($nomor)"
  set_state "idle"
  return
fi

# LIST
if [[ "$msg" == "📋 List" ]]; then
  text="📋 DATA:\n"
  while read u w e; do
    text+="\n$u | $w | $e"
  done < $DATA
  send_tg "$text"
  return
fi

# KIRIM
if [[ "$msg" == "📤 Kirim" ]]; then
  send_tg "Masukkan pesan:"
  set_state "kirim"
  return
fi

if [[ "$state" == "kirim" ]]; then
  jumlah=0
  while read u w e; do
    send_wa "$w" "$msg"
    jumlah=$((jumlah+1))
  done < $DATA

  send_tg "✅ Terkirim ke $jumlah user"
  set_state "idle"
  return
fi

# HAPUS
if [[ "$msg" == "❌ Hapus" ]]; then
  send_tg "Masukkan nomor:"
  set_state "hapus"
  return
fi

if [[ "$state" == "hapus" ]]; then
  sed -i "/$msg/d" $DATA
  send_tg "❌ Dihapus"
  set_state "idle"
  return
fi

}

# ================= LOOP =================

last_update=$(cat $OFFSET_FILE)

while true; do
  response=$(curl -s "https://api.telegram.org/bot$TOKEN/getUpdates?offset=$last_update")

  echo "$response" | jq -c '.result[]?' | while read update; do
    update_id=$(echo "$update" | jq '.update_id')
    message=$(echo "$update" | jq -r '.message.text // empty')

    [[ -z "$message" ]] && continue

    last_update=$((update_id+1))
    echo "$last_update" > $OFFSET_FILE

    handle_command "$message"
  done

  sleep 2
done
EOF

chmod +x $HOME/bot-wa.sh
