#!/data/data/com.termux/files/usr/bin/bash

clear
echo "================================="
echo " AUTO INSTALL BOT TERMUX 🔥 "
echo "================================="

# AUTO ISI
TOKEN="8290196740:AAGAMlvolfPinlOIQMkrgsB1kgOjtSBU0zc"
CHAT_ID="1386780002"
FONNTE="odCdkwttceRZM4VdaPti"

echo "[INFO] Install dependency..."
pkg update -y >/dev/null 2>&1
pkg install -y jq curl >/dev/null 2>&1

echo "[INFO] Setup bot..."

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
-d text="$1"
}

send_wa() {
curl -s -X POST "https://api.fonnte.com/send" \
-H "Authorization: $FONNTE" \
-d "target=$1" \
-d "message=$2"
}

handle_command() {
msg="$1"

if [[ $msg == /tambah* ]]; then
  user=$(echo "$msg" | awk '{print $2}')
  wa=$(echo "$msg" | awk '{print $3}')
  exp=$(echo "$msg" | awk '{print $4}')
  echo "$user $wa $exp" >> $DATA
  send_tg "Ditambahkan: $user ($wa)"
fi

if [[ $msg == /hapus* ]]; then
  wa=$(echo "$msg" | awk '{print $2}')
  sed -i "/$wa/d" $DATA
  send_tg "Dihapus: $wa"
fi

if [[ $msg == /list ]]; then
  send_tg "$(cat $DATA)"
fi
}

check_expired() {
today=$(date +"%Y-%m-%d")

while read user wa exp; do
  [[ -z "$user" ]] && continue

  if [[ "$exp" == "$today" ]]; then
    send_wa "$wa" "Halo $user, akun kamu expired hari ini"
    send_tg "Kirim ke $user"
  fi

  if [[ "$exp" < "$today" ]]; then
    sed -i "/$wa/d" $DATA
  fi

done < $DATA
}

last_update=0

while true; do
  hour=$(date +"%H")

  if [[ "$hour" == "18" ]]; then
    check_expired
    sleep 3600
  fi

  response=$(curl -s --max-time 10 "https://api.telegram.org/bot$TOKEN/getUpdates?offset=$last_update")

  [[ -z "$response" ]] && sleep 5 && continue

  update_id=$(echo "$response" | jq '.result[-1].update_id')
  message=$(echo "$response" | jq -r '.result[-1].message.text')

  if [[ "$update_id" != "null" ]]; then
    last_update=$((update_id+1))
    handle_command "$message"
  fi

  sleep 3
done
EOF

# inject token
sed -i "s|__TOKEN__|$TOKEN|g" $HOME/bot-wa/bot.sh
sed -i "s|__CHAT_ID__|$CHAT_ID|g" $HOME/bot-wa/bot.sh
sed -i "s|__FONNTE__|$FONNTE|g" $HOME/bot-wa/bot.sh

chmod +x $HOME/bot-wa/bot.sh

echo ""
echo "================================="
echo " INSTALL SELESAI ✅"
echo "================================="
echo ""
echo "Jalankan bot dengan:"
echo "bash $HOME/bot-wa/bot.sh"
