# 🤖 BOT WA + TELEGRAM (TERMUX VERSION — ANTI GAGAL)

Bot ini bisa:

* Kirim WhatsApp via Fonnte
* Kontrol lewat Telegram
* Jalan di HP (Termux)
* Stabil & ringan ✅

---

# 🚀 1. INSTALL TERMUX (WAJIB BENAR)

❗ Jangan pakai dari Play Store (sering error)

Download dari sini:
👉 https://f-droid.org/packages/com.termux/

---

# ⚙️ 2. SETUP AWAL TERMUX

Buka Termux → jalankan:

```bash
termux-change-repo
```

Pilih:

* ✔ Mirror group
* ✔ Main repository
* ✔ Pilih mirror:

  * Grimler (Singapore) ⭐
  * Cloudflare

❌ Jangan pilih **textcord** (sering error)

---

# 🔄 3. UPDATE & INSTALL DEPENDENCY

```bash
pkg update -y && pkg upgrade -y
pkg install curl jq wget tmux -y
```

---

# 🔍 4. TEST TERMUX (PENTING BANGET)

```bash
curl https://google.com
```

### 👉 Kalau hasil seperti ini:

```html
<HTML><HEAD>...
```

✔ Artinya: Termux normal → lanjut ✅

---

### ❌ Kalau error seperti ini:

```
Failed to connect
Could not resolve host
```

👉 Artinya: internet / repo bermasalah
👉 **JANGAN lanjut — perbaiki dulu**

---

# 🚀 5. DOWNLOAD SCRIPT BOT

```bash
wget https://raw.githubusercontent.com/sweaterpink1999/notif-wa/main/install-bot-wa.sh
```

---

# 🔧 6. FIX AGAR COMPATIBLE TERMUX

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

Kalau berhasil akan muncul:

```
INSTALL SELESAI
```

---

# ▶️ 8. JALANKAN BOT

```bash
bash $HOME/bot-wa/bot.sh
```

---

# 🔥 9. BIAR BOT TIDAK MATI

```bash
tmux
bash $HOME/bot-wa/bot.sh
```

Keluar tanpa mematikan bot:

```
CTRL + B lalu D
```

Masuk lagi:

```bash
tmux attach
```

---

# 📲 CARA PAKAI BOT

### ➕ Tambah user

```
/tambah nama 628xxxx 2026-04-09
```

### 📋 Lihat data

```
/list
```

### ❌ Hapus user

```
/hapus 628xxxx
```

### 📤 Kirim WA langsung

```
/kirim nama 628xxxx pesan
```

---

# ⚠️ HAL PENTING (SERING SALAH)

## 1. Format nomor WA

```
628xxxx ❌ benar
08xxxx  ❌ salah
```

---

## 2. Telegram

* Wajib klik **START**
* Chat ID harus benar

---

## 3. Fonnte

* Status harus **CONNECTED**
* Token harus valid

---

# 💥 TROUBLESHOOTING

## ❌ Bot tidak respon

* Belum klik START
* Bot belum jalan

---

## ❌ WA tidak masuk

* Nomor salah (08 bukan 628)
* Fonnte belum connect
* Token salah

---

## ❌ Bot berhenti

Jalankan ulang:

```bash
bash $HOME/bot-wa/bot.sh
```

---

# 🔥 TIPS SUPAYA TIDAK GAGAL

✔ Ikuti step dari atas (jangan lompat)
✔ Selalu test `curl google` dulu
✔ Jangan pakai repo textcord
✔ Gunakan Termux dari F-Droid

---

# 🚀 HASIL AKHIR (JIKA BERHASIL)

✔ Bot jalan terus
✔ Telegram bisa kontrol
✔ WA berhasil terkirim

---

# 👨‍💻 AUTHOR

By: kamu 😎
Upgrade: Anti Gagal Version 🔥
