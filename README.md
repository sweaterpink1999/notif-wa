# 🤖 BOT TAGIHAN WA + TELEGRAM (TERMUX VERSION)

Bot otomatis untuk:

* Kirim tagihan WhatsApp (via Fonnte)
* Kontrol via Telegram
* Auto kirim jam 18:00
* Auto hapus user expired
* Jalan di Termux (HP) ✅

---

# 🚀 1. INSTALL TERMUX (WAJIB)

❗ **Jangan pakai Termux dari Play Store**

Download dari sini:
👉 https://f-droid.org/packages/com.termux/

---

# ⚙️ 2. SETUP AWAL TERMUX

Buka Termux lalu jalankan:

```bash
termux-change-repo
```

Pilih:

* ✔ Mirror group
* ✔ Main repository
* ✔ Pilih mirror:

  * Grimler (Singapore) ✅
  * Cloudflare ✅

❌ Jangan pilih textcord

---

# 🔄 3. UPDATE & INSTALL DEPENDENCY

```bash
pkg update -y && pkg upgrade -y
pkg install curl jq wget tmux -y
```

---

# 🚀 4. INSTALL BOT (AUTO)

Copy–paste ini:

```bash
pkg update -y && pkg install -y curl jq wget tmux && \
wget -O install-bot-wa.sh https://raw.githubusercontent.com/sweaterpink1999/notif-wa/main/install-bot-wa.sh && \
sed -i 's|/root|$HOME|g' install-bot-wa.sh && \
sed -i 's|/root/bot-wa|$HOME/bot-wa|g' install-bot-wa.sh && \
sed -i '/systemctl/d' install-bot-wa.sh && \
sed -i 's|apt |pkg |g' install-bot-wa.sh && \
sed -i 's|/bin/bash|/data/data/com.termux/files/usr/bin/bash|g' install-bot-wa.sh && \
bash install-bot-wa.sh
```

---

# ▶️ 5. JALANKAN BOT

```bash
bash $HOME/bot-wa/bot.sh
```

---

# 🔥 6. JALANKAN DI BACKGROUND (WAJIB)

```bash
tmux
bash $HOME/bot-wa/bot.sh
```

Keluar tanpa mematikan bot:

```
CTRL + B lalu tekan D
```

Masuk kembali:

```bash
tmux attach
```

---

# 🔑 CONFIG

Bot sudah otomatis menggunakan:

* TOKEN TELEGRAM ✅
* CHAT ID ✅
* TOKEN FONNTE ✅

(Tidak perlu input manual)

---

# 📲 CARA PAKAI BOT

### ➕ Tambah User

```
/tambah nama 628xxxx 2026-04-09
```

Contoh:

```
/tambah user1 628123456789 2026-04-09
```

---

### ❌ Hapus User

```
/hapus 628xxxx
```

---

### 📋 List User

```
/list
```

---

# ⏰ AUTO SYSTEM

Bot akan otomatis:

* Kirim WhatsApp jam **18:00**
* Hanya kirim jika tanggal sesuai
* Tidak kirim sebelum waktunya
* Hapus user jika sudah lewat tanggal

---

# 📦 FORMAT DATA

```
nama nomor tanggal_expired
```

Contoh:

```
user1 628123456789 2026-04-09
```

---

# ⚠️ CATATAN PENTING

* Format nomor WA:

```
628xxxx (tanpa 0)
```

* Pastikan:

  * Bot Telegram sudah klik **START**
  * Fonnte dalam kondisi **connected**

---

# 🔥 FITUR

* ✔ Kirim WA otomatis
* ✔ Kontrol via Telegram
* ✔ Auto delete expired user
* ✔ Anti stuck (pakai timeout)
* ✔ Tidak perlu VPS
* ✔ Jalan di HP (Termux)

---

# 💥 TROUBLESHOOTING

### Bot tidak respon

* Pastikan sudah klik **START** di Telegram

### WA tidak terkirim

* Cek token Fonnte
* Cek nomor format 628xxxx

### Bot berhenti

Jalankan ulang:

```bash
bash $HOME/bot-wa/bot.sh
```

---

# 👨‍💻 AUTHOR

By: kamu sendiri 😎
Upgrade: Termux Version Anti Stuck 🔥
