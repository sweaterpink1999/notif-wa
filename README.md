# 🤖 BOT WA + TELEGRAM (TERMUX VERSION — ANTI GAGAL)

Bot untuk:

* Kirim WhatsApp via Fonnte
* Kontrol dari Telegram
* Jalan di Termux (HP)
* Stabil & anti error ✅

---

# 🚀 1. INSTALL TERMUX (WAJIB)

❗ **JANGAN pakai Play Store**

Download di sini:
👉 https://f-droid.org/packages/com.termux/

---

# ⚙️ 2. SETUP AWAL (PENTING BANGET)

Buka Termux lalu:

```bash
termux-change-repo
```

Pilih:

* ✔ Mirror group
* ✔ Main repository
* ✔ Pilih salah satu:

  * Grimler (Singapore) ⭐
  * Cloudflare

❌ Jangan pilih textcord (error)

---

# 🔄 3. UPDATE & INSTALL

```bash
pkg update -y && pkg upgrade -y
pkg install curl jq wget tmux -y
```

---

# 🔍 4. TEST TERMUX (WAJIB)

```bash
curl https://google.com
```

👉 Kalau muncul HTML → lanjut
👉 Kalau error → jangan lanjut (fix dulu)

---

# 🚀 5. INSTALL BOT

```bash
wget https://raw.githubusercontent.com/sweaterpink1999/notif-wa/main/install-bot-wa.sh
```

---

# 🔧 6. FIX UNTUK TERMUX

```bash
sed -i 's|/root|$HOME|g' install-bot-wa.sh
sed -i '/systemctl/d' install-bot-wa.sh
sed -i 's|apt |pkg |g' install-bot-wa.sh
sed -i 's|/bin/bash|/data/data/com.termux/files/usr/bin/bash|g' install-bot-wa.sh
```

---

# ▶️ 7. JALANKAN INSTALL

```bash
bash install-bot-wa.sh
```

---

# ▶️ 8. JALANKAN BOT

```bash
bash $HOME/bot-wa/bot.sh
```

---

# 🔥 9. JALANKAN DI BACKGROUND

```bash
tmux
bash $HOME/bot-wa/bot.sh
```

Keluar:

```
CTRL + B lalu D
```

Masuk lagi:

```bash
tmux attach
```

---

# 📲 CARA PAKAI

### ➕ Tambah user

```
/tambah nama 628xxxx 2026-04-09
```

### 📋 List user

```
/list
```

### ❌ Hapus user

```
/hapus 628xxxx
```

### 📤 Kirim WA

```
/kirim nama 628xxxx pesan
```

---

# ⚠️ WAJIB DIPERHATIKAN

## 1. Format nomor WA

```
628xxxx (bukan 08xxxx)
```

---

## 2. Telegram

* Harus klik **START**
* Chat ID harus benar

---

## 3. Fonnte

* Harus **CONNECTED**
* Token harus valid

---

# 💥 TROUBLESHOOTING

## ❌ Bot tidak respon

✔ belum klik START
✔ bot tidak jalan

---

## ❌ WA tidak terkirim

✔ nomor salah
✔ Fonnte offline
✔ token salah

---

## ❌ Bot berhenti

Jalankan ulang:

```bash
bash $HOME/bot-wa/bot.sh
```

---

# 🔥 TIPS ANTI GAGAL

✔ Jangan skip step
✔ Selalu test `curl google` dulu
✔ Jangan pakai repo textcord
✔ Pastikan pakai Termux F-Droid

---

# 🚀 STATUS AKHIR

Kalau berhasil:

* Bot jalan terus
* Telegram respon
* WA bisa terkirim

---

# 👨‍💻 AUTHOR

By: kamu 😎
Upgrade: Anti Gagal Version 🔥
