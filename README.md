# 🤖 BOT WA + TELEGRAM (TERMUX VERSION — FINAL STABLE)

Bot ini bisa:

✅ Kirim WhatsApp via Fonnte
✅ Kontrol lewat Telegram (pakai tombol)
✅ Support tanggal kadaluarsa (expired)
✅ Anti spam (fix offset bug)
✅ Stabil jalan di HP (Termux)

---

# 🚀 1. INSTALL TERMUX

❗ WAJIB dari F-Droid:
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

✔ Kalau muncul HTML → lanjut
❌ Kalau gagal → cek jaringan

---

# 🚀 5. DOWNLOAD SCRIPT

```bash
wget https://raw.githubusercontent.com/sweaterpink1999/notif-wa/main/install-bot-wa.sh
```

---

# 🔧 6. FIX TERMUX (WAJIB)

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

🟢 Saat install isi:

* TOKEN Telegram
* CHAT ID
* API Fonnte

---

# ▶️ 8. JALANKAN BOT (ANTI MATI)

```bash
tmux
while true; do bash $HOME/bot-wa.sh; sleep 3; done
```

Keluar:
CTRL + B → D

Masuk lagi:

```bash
tmux attach
```

---

# 📲 CARA PAKAI (TELEGRAM)

Ketik:

```bash
/start
```

Lalu gunakan tombol 👇

---

## ➕ Tambah

Klik:

```
➕ Tambah
```

Lalu kirim:

```
628xxxx 2026-05-01
```

✔ Format:

* Nomor WA (628xxx)
* Tanggal expired (YYYY-MM-DD)

---

## 📋 List

Klik:

```
📋 List
```

✔ Menampilkan semua data nomor + expired

---

## 📤 Kirim

Klik:

```
📤 Kirim
```

Lalu ketik pesan:

```
Halo ini pesan promo
```

✔ Hanya terkirim ke nomor aktif (belum expired)

---

## ❌ Hapus

Klik:

```
❌ Hapus
```

✔ Menghapus semua nomor yang sudah expired

---

# ⚠️ PENTING

✅ Format nomor:

```
628xxxx
```

❌ Jangan:

```
08xxxx
```

---

✅ Format tanggal:

```
2026-05-01
```

❌ Jangan:

```
01-05-2026
```

---

✅ Pastikan:

* Fonnte CONNECTED
* Sudah klik `/start`
* Bot berjalan di tmux

---

# 💥 TROUBLESHOOTING

## ❌ Bot tidak respon

* Belum `/start`
* Bot belum jalan
* Coba restart:

```bash
tmux attach
```

---

## ❌ Bot spam

✔ Sudah diperbaiki di versi ini
👉 Pastikan install ulang script terbaru

---

## ❌ WA tidak masuk

* Nomor salah
* Token Fonnte salah
* Device Fonnte belum connect

---

## ❌ Tombol tidak muncul

Ketik ulang:

```
/start
```

---

# 🔐 KEAMANAN

⚠️ JANGAN SHARE:

* TOKEN Telegram
* API Fonnte
* CHAT ID

Kalau bocor:
👉 segera ganti token

---

# 👨‍💻 AUTHOR

By: sweaterpink1999 😎
Version: FINAL STABLE (ANTI SPAM + BUTTON + EXPIRED) 🔥

---

# 🚀 NEXT UPGRADE (OPSIONAL)

Kalau mau upgrade:

* 🔔 Notifikasi sebelum expired
* 👥 Multi user
* 🌐 Web panel
* 💰 Sistem langganan

👉 Tinggal bilang: **upgrade premium** 😎
