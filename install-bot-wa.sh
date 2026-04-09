#!/bin/bash

clear
echo "================================="
echo " AUTO INSTALL BOT (ANTI STUCK) "
echo "================================="

TOKEN="$1"
CHAT_ID="$2"
FONNTE="$3"

if [[ -z "$TOKEN" || -z "$CHAT_ID" || -z "$FONNTE" ]]; then
  echo ""
  echo "❌ Cara pakai salah!"
  echo ""
  echo "Gunakan:"
  echo "bash install-bot-wa.sh TOKEN CHAT_ID TOKEN_FONNTE"
  exit 1
fi

echo "[INFO] Setup bot..."

mkdir -p /root/bot-wa
touch /root/bot-wa/datauser.txt

cat > /root/bot-wa/bot.sh << 'EOF'
#!/bin/bash

TOKEN="__TOKEN__"
CHAT_ID="__CHAT_ID__"
FONNTE="__FONNTE__"
DATA="/root/bot-wa/datauser.txt"

send_tg() {
curl -s -X POST https://api.telegram.org/bot$TOKEN/sendMessage \
-d chat_id=$CHAT_ID \
-d text="$1" > /dev/null
}

send_wa() {
curl -s -X POST https://api.fonnte.com/send \
-H "Authorization: $FONNTE" \
-d "target=$1" \
-d "message=$2" > /dev/null
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
  list=$(cat $DATA)
  send_tg "DATA:\n$list"
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

  response=$(curl -s "https://api.telegram.org/bot$TOKEN/getUpdates?offset=$last_update")
  update_id=$(echo "$response" | jq '.result[-1].update_id')
  message=$(echo "$response" | jq -r '.result[-1].message.text')

  if [[ "$update_id" != "null" ]]; then
    last_update=$((update_id+1))
    handle_command "$message"
  fi

  sleep 5
done
EOF

# inject token
sed -i "s|__TOKEN__|$TOKEN|g" /root/bot-wa/bot.sh
sed -i "s|__CHAT_ID__|$CHAT_ID|g" /root/bot-wa/bot.sh
sed -i "s|__FONNTE__|$FONNTE|g" /root/bot-wa/bot.sh

chmod +x /root/bot-wa/bot.sh

echo "[INFO] Setup service..."

cat > /etc/systemd/system/bot-wa.service <<EOF
[Unit]
Description=Bot WA Fast
After=network.target

[Service]
ExecStart=/bin/bash /root/bot-wa/bot.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable bot-wa
systemctl restart bot-wa

echo ""
echo "================================="
echo " INSTALL SELESAI 🔥"
echo "================================="
