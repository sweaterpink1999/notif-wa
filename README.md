# 🤖 BOT TAGIHAN WA + TELEGRAM

Bot otomatis untuk:

* Kirim tagihan WhatsApp (via Fonnte)
* Kontrol via Telegram
* Auto kirim jam 18:00
* Auto hapus user yang expired

---

## 🚀 INSTALL (AUTO)

Jalankan di VPS:

```bash
wget https://raw.githubusercontent.com/sweaterpink1999/notif-wa/main/install-bot-wa.sh && bash install-bot-wa.sh
```

---

## 🔑 YANG DIBUTUHKAN

Saat install, masukkan:

* Token Telegram Bot
* Chat ID Telegram
* Token Fonnte

---

## 📲 CARA PAKAI BOT

### ➕ Tambah User

```bash
/tambah nama 628xxxx 2026-04-09
```

Contoh:

```bash
/tambah user1 628123456789 2026-04-09
```

---

### ❌ Hapus User

```bash
/hapus 628xxxx
```

---

### 📋 List User

```bash
/list
```

---

## ⏰ AUTO SYSTEM

Bot akan otomatis:

* Kirim WhatsApp jam **18:00**
* Hanya kirim jika tanggal **sesuai**
* Tidak kirim jika belum tanggal
* Hapus user jika sudah **lewat tanggal**

---

## 📦 FORMAT DATA

```text
nama nomor tanggal_expired
```

Contoh:

```text
user1 628123456789 2026-04-09
```

---

## ⚙️ SERVICE

Cek status bot:

```bash
systemctl status bot-wa
```

Restart bot:

```bash
systemctl restart bot-wa
```

Stop bot:

```bash
systemctl stop bot-wa
```

---

## 🔥 FITUR

* ✔ Kirim WA otomatis
* ✔ Kontrol via Telegram
* ✔ Auto delete expired user
* ✔ Auto running (systemd)
* ✔ Tidak perlu VPS mahal

---

## ⚠️ CATATAN

* Nomor WA harus format:

```
628xxxx (tanpa 0)
```

* Pastikan WhatsApp (Fonnte) tetap connected

---

## 👨‍💻 AUTHOR

By: kamu sendiri 😎
