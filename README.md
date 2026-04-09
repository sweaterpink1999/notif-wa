# 🤖 BOT WA + TELEGRAM (TERMUX VERSION — STABLE)

Bot ini bisa:

* Kirim WhatsApp via Fonnte
* Kontrol lewat Telegram
* Jalan di HP (Termux)
* Stabil & ringan ✅

---

# 🚀 1. INSTALL TERMUX

❗ Gunakan dari F-Droid (WAJIB)

https://f-droid.org/packages/com.termux/

---

# ⚙️ 2. SETUP TERMUX

```bash
termux-change-repo
```

Pilih:

* Mirror group
* Main repository
* Grimler / Cloudflare

---

# 🔄 3. INSTALL DEPENDENCY

```bash
pkg update -y && pkg upgrade -y
pkg install curl jq wget tmux -y
```

---

# 🔍 4. TEST INTERNET

```bash
curl https://google.com
```

✔ Kalau berhasil → lanjut
❌ Kalau gagal → jangan lanjut

---

# 🚀 5. DOWNLOAD SCRIPT

```bash
wget https://raw.githubusercontent.com/sweaterpink1999/notif-wa/main/install-bot-wa.sh
```

---

# 🔧 6. FIX TERMUX

```bash
sed -i 's|/root|$HOME|g' install-bot-wa.sh
sed -i '/systemctl/d' install-bot-wa.sh
sed -i 's|apt |pkg |g' install-bot-wa.sh
sed -i 's|/bin/bash|/data/data/com.termux/files/usr/bin/bash|g' install-bot-wa.sh
```

---

# ▶️ 7. INSTALL BOT

```bash
bash install-bot-wa.sh
```

---

# ▶️ 8. JALANKAN BOT

```bash
bash $HOME/bot-wa.sh
```

---

# 🔥 9. AGAR BOT TIDAK MATI

```bash
tmux
bash $HOME/bot-wa.sh
```

Keluar:
CTRL + B → D

Masuk lagi:

```bash
tmux attach
```

---

# 📲 CARA PAKAI

## ➕ Tambah user

Ketik di Telegram:

```
➕ Tambah
```

## 📋 List

```
📋 List
```

## 📤 Kirim

```
📤 Kirim
```

## ❌ Hapus

```
❌ Hapus
```

---

# ⚠️ PENTING

* Nomor WA wajib format:
  628xxxx ✅
* Fonnte harus CONNECTED
* Klik START di Telegram

---

# 💥 TROUBLESHOOTING

## Bot tidak respon

* Belum /start
* Bot belum jalan

## WA tidak masuk

* Nomor salah
* Token salah
* Fonnte belum connect

---

# 👨‍💻 AUTHOR

By: sweaterpink1999 😎
Version: Stable Termux 🔥
