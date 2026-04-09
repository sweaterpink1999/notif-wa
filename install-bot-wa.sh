

#!/data/data/com.termux/files/usr/bin/bash

clear
echo "================================="
echo " INSTALL BOT WA TERMUX 🔥"
echo " ANTI SPAM VERSION"
echo "================================="

# ====== CONFIG ======
TOKEN="8290196740:AAGAMlvolfPinlOIQMkrgsB1kgOjtSBU0zc"
CHAT_ID="1386780002"
FONNTE="odCdkwttceRZM4VdaPti"

# ====== DEPENDENCY ======
echo "[INFO] Install dependency..."
pkg update -y >/dev/null 2>&1
pkg install -y curl jq tmux >/dev/null 2>&1

# ====== CLEAN OLD ======
echo "[INFO] Cleaning old data..."
rm -f $HOME/offset.txt
rm -f $HOME/datauser.txt

# ====== RESET TELEGRAM UPDATE (ANTI SPAM) ======
echo "[INFO] Reset Telegram updates..."
curl -s "https://api.telegram.org/bot$TOKEN/getUpdates" > /dev/null
sleep 1
curl -s "https://api.telegram.org/bot$TOKEN/getUpdates" > /dev/null

# ====== SETUP FILE ======
touch $HOME/datauser.txt
touch $HOME/offset.txt

# ambil offset terbaru
LAST=$(curl -s "https://api.telegram.org/bot$TOKEN/getUpdates" | jq '.result[-1].update_id // 0')
OFFSET=$((LAST+1))
echo $OFFSET > $HOME/offset.txt

# ====== BUAT BOT ======
cat > $HOME/bot-wa.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

TOKEN="__TOKEN__"
CHAT_ID="__CHAT_ID__"
FONNTE="__FONNTE__"

DATA="$HOME/datauser.txt"
OFFSET="$HOME/offset.txt"

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

handle() {
msg="$1"

[[ -z "$msg" ]] && return

if [[ $msg == /start ]]; then
send_tg "🤖 BOT AKTIF"
fi

if [[ $msg == /tambah* ]]; then
echo "$msg" | awk '{print $2,$3,$4}' >> $DATA
send_tg "✅ Ditambahkan"
fi

if [[ $msg == /list ]]; then
send_tg "$(cat $DATA)"
fi

if [[ $msg == /kirim* ]]; then
text=$(echo "$msg" | cut -d' ' -f2-)
while read u w e; do
send_wa "$w" "$text"
done < $DATA
send_tg "✅ Terkirim"
fi
}

offset=$(cat $OFFSET)

while true; do
res=$(curl -s https://api.telegram.org/bot$TOKEN/getUpdates?offset=$offset)

echo "$res" | jq -c '.result[]?' | while read u; do
id=$(echo "$u" | jq '.update_id')
msg=$(echo "$u" | jq -r '.message.text // empty')

[[ -z "$msg" ]] && continue

offset=$((id+1))
echo $offset > $OFFSET

handle "$msg"
done

sleep 2
done
EOF

# inject token
sed -i "s|__TOKEN__|$TOKEN|g" $HOME/bot-wa.sh
sed -i "s|__CHAT_ID__|$CHAT_ID|g" $HOME/bot-wa.sh
sed -i "s|__FONNTE__|$FONNTE|g" $HOME/bot-wa.sh

chmod +x $HOME/bot-wa.sh

echo ""
echo "================================="
echo " INSTALL SELESAI ✅"
echo "================================="
echo ""
echo "Jalankan bot:"
echo "bash ~/bot-wa.sh"
