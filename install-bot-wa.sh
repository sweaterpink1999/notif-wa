#!/data/data/com.termux/files/usr/bin/bash

TOKEN="__TOKEN__"
CHAT_ID="__CHAT_ID__"
FONNTE="__FONNTE__"
DATA="$HOME/bot-wa/datauser.txt"

send_tg() {
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
-d chat_id="$CHAT_ID" \
-d text="$1" > /dev/null
}

send_menu() {
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
-d chat_id="$CHAT_ID" \
-d text="🤖 MENU BOT\nPilih menu:" \
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

handle_command() {
msg="$1"

# START
if [[ "$msg" == "/start" ]]; then
  send_menu
fi

# MENU BUTTON
if [[ "$msg" == "📋 List" ]]; then
  send_tg "$(cat $DATA)"
fi

if [[ "$msg" == "➕ Tambah" ]]; then
  send_tg "Gunakan:\n/tambah nama nomor tanggal(YYYY-MM-DD)"
fi

if [[ "$msg" == "❌ Hapus" ]]; then
  send_tg "Gunakan:\n/hapus nomor"
fi

if [[ "$msg" == "📤 Kirim" ]]; then
  send_tg "Gunakan:\n/kirim pesan"
fi

# TAMBAH
if [[ $msg == /tambah* ]]; then
  user=$(echo "$msg" | awk '{print $2}')
  wa=$(echo "$msg" | awk '{print $3}')
  exp=$(echo "$msg" | awk '{print $4}')

  echo "$user $wa $exp" >> $DATA
  send_tg "Ditambahkan: $user ($wa)"
fi

# HAPUS
if [[ $msg == /hapus* ]]; then
  wa=$(echo "$msg" | awk '{print $2}')
  sed -i "/$wa/d" $DATA
  send_tg "Dihapus: $wa"
fi

# LIST
if [[ $msg == /list ]]; then
  send_tg "$(cat $DATA)"
fi

# 🔥 KIRIM KE EXPIRED HARI INI
if [[ $msg == /kirim* ]]; then
  text=$(echo "$msg" | cut -d' ' -f2-)
  today=$(date +"%Y-%m-%d")

  jumlah=0

  while read user wa exp; do
    [[ -z "$user" ]] && continue

    if [[ "$exp" == "$today" ]]; then
      send_wa "$wa" "Halo $user, $text"
      jumlah=$((jumlah+1))
    fi

  done < $DATA

  send_tg "✅ Berhasil kirim ke $jumlah user (expired hari ini)"
fi
}

last_update=0

while true; do
  response=$(curl -s --max-time 10 "https://api.telegram.org/bot$TOKEN/getUpdates?offset=$last_update")

  echo "$response" | jq -c '.result[]' | while read update; do
    update_id=$(echo "$update" | jq '.update_id')
    message=$(echo "$update" | jq -r '.message.text')

    if [[ "$update_id" != "null" && "$update_id" -ge "$last_update" ]]; then
      last_update=$((update_id+1))
      handle_command "$message"
    fi
  done

  sleep 2
done
