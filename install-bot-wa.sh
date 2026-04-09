#!/data/data/com.termux/files/usr/bin/bash

clear
echo "================================="
echo " BOT TERMUX STABLE + MENU 🔥 "
echo "================================="

# CONFIG
TOKEN="8290196740:AAGAMlvolfPinlOIQMkrgsB1kgOjtSBU0zc"
CHAT_ID="1386780002"
FONNTE="odCdkwttceRZM4VdaPti"

pkg update -y >/dev/null 2>&1
pkg install -y jq curl >/dev/null 2>&1

mkdir -p $HOME/bot-wa
touch $HOME/bot-wa/datauser.txt

cat > $HOME/bot-wa/bot.sh << 'EOF'
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

# START MENU
if [[ "$msg" == "/start" ]]; then
  send_menu
fi

# TOMBOL
if [[ "$msg" == "📋 List" ]]; then
  send_tg "$(cat $DATA)"
fi

if [[ "$msg" == "📤 Kirim" ]]; then
  send_tg "Gunakan:\n/kirim nama nomor pesan"
fi

if [[ "$msg" == "➕ Tambah" ]]; then
  send_tg "Gunakan:\n/tambah nama nomor tanggal"
fi

if [[ "$msg" == "❌ Hapus" ]]; then
  send_tg "Gunakan:\n/hapus nomor"
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

# KIRIM WA
if [[ $msg == /kirim* ]]; then
  user=$(echo "$msg" | awk '{print $2}')
  wa=$(echo "$msg" | awk '{print $3}')
  pesan=$(echo "$msg" | cut -d' ' -f4-)

  [[ -z "$pesan" ]] && pesan="Halo $user, ini pesan dari bot"

  send_wa "$wa" "$pesan"
  send_tg "Berhasil kirim ke $user ($wa)"
fi
}

last_update=0

while true; do
  response=$(curl -s --max-time 10 "https://api.telegram.org/bot$TOKEN/getUpdates?offset=$last_update")

  echo "$response" | jq -c '.result[]' | while read update; do
    update_id=$(echo "$update" | jq '.update_id')
    message=$(echo "$update" | jq -r '.message.text')

    if [[ "$update_id" != "null" ]]; then
      last_update=$((update_id+1))
      handle_command "$message"
    fi
  done

  sleep 2
done
EOF

# inject token
sed -i "s|__TOKEN__|$TOKEN|g" $HOME/bot-wa/bot.sh
sed -i "s|__CHAT_ID__|$CHAT_ID|g" $HOME/bot-wa/bot.sh
sed -i "s|__FONNTE__|$FONNTE|g" $HOME/bot-wa/bot.sh

chmod +x $HOME/bot-wa/bot.sh

echo ""
echo "================================="
echo " INSTALL SELESAI (STABLE) ✅"
echo "================================="
echo ""
echo "Jalankan:"
echo "bash $HOME/bot-wa/bot.sh"
