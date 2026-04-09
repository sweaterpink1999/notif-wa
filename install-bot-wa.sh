#!/data/data/com.termux/files/usr/bin/bash

# ================= CONFIG =================
TOKEN="8290196740:AAGAMlvolfPinlOIQMkrgsB1kgOjtSBU0zc"
CHAT_ID="1386780002"
FONNTE="odCdkwttceRZM4VdaPti"
DATA="$HOME/bot-wa/datauser.txt"

mkdir -p $HOME/bot-wa
touch $DATA

# ================= FUNCTION =================

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
📤 Kirim (Expired Hari Ini)
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

# ================= COMMAND =================

handle_command() {
msg="$1"

# START
if [[ "$msg" == "/start" ]]; then
  send_menu
fi

# MENU BUTTON
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
fi

if [[ "$msg" == "➕ Tambah" ]]; then
  send_tg "Gunakan:\n/tambah nama nomor tanggal\n\nContoh:\n/tambah budi 628xxxx 2026-04-10"
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

  if [[ -z "$user" || -z "$wa" || -z "$exp" ]]; then
    send_tg "❌ Format salah!\n/tambah nama nomor tanggal"
    return
  fi

  echo "$user $wa $exp" >> $DATA
  send_tg "✅ Ditambahkan: $user ($wa)"
fi

# HAPUS
if [[ $msg == /hapus* ]]; then
  wa=$(echo "$msg" | awk '{print $2}')

  if grep -q "$wa" $DATA; then
    sed -i "/$wa/d" $DATA
    send_tg "❌ Dihapus: $wa"
  else
    send_tg "⚠️ Nomor tidak ditemukan"
  fi
fi

# LIST COMMAND
if [[ $msg == /list ]]; then
  handle_command "📋 List"
fi

# ================= KIRIM EXPIRED =================
if [[ $msg == /kirim* ]]; then
  text=$(echo "$msg" | cut -d' ' -f2-)
  today=$(date +"%Y-%m-%d")

  if [[ -z "$text" ]]; then
    send_tg "❌ Masukkan pesan!\n/kirim pesan"
    return
  fi

  jumlah=0

  while read user wa exp; do
    [[ -z "$user" ]] && continue

    if [[ "$exp" == "$today" ]]; then
      send_wa "$wa" "⚠️ NOTIF\nHalo $user,\n$text"
      jumlah=$((jumlah+1))
    fi

  done < $DATA

  send_tg "✅ Berhasil kirim ke $jumlah user hari ini"
fi

}

# ================= LOOP =================

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
