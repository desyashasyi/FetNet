# Deploy FetNet ke Server (Docker)

Panduan deploy aplikasi FetNet ke server produksi `fetnet.techupi.id`.

## Prasyarat Server

- Docker Engine ≥ 24 + Docker Compose v2 (`docker compose`)
- `make`, `git`
- Nginx (sebagai reverse proxy host) + `certbot` (untuk TLS opsional)
- DNS `fetnet.techupi.id` sudah arahkan ke IP server

## Langkah Deploy

```bash
# 1. Clone repo ke folder hosting
git clone <repo-url> /var/www/fetnet
cd /var/www/fetnet

# 2. Jalankan stack (auto build + migrate + seed)
make up

# 3. Pasang reverse proxy host
sudo cp docs/fetnet.conf /etc/nginx/sites-available/fetnet.conf
sudo ln -s /etc/nginx/sites-available/fetnet.conf /etc/nginx/sites-enabled/fetnet.conf
sudo nginx -t && sudo systemctl reload nginx
```

Aplikasi langsung bisa diakses di `http://fetnet.techupi.id`.

## Apa yang `make up` Lakukan Otomatis

Container `fetnet-app` punya env `BOOTSTRAP_APP=1` yang memicu `.docker/php/entrypoint.sh`:

1. Copy `.env.example` → `.env` jika belum ada
2. `composer install` jika `vendor/` kosong
3. `php artisan key:generate --force` jika `APP_KEY` kosong
4. `php artisan migrate --force` (retry hingga 15× jika DB belum siap)
5. `php artisan db:seed --force` (idempotent — pakai `firstOrCreate`)
6. `php artisan storage:link` jika belum
7. `npm install && npm run build` jika `public/build/` belum ada

Worker container (`fetnet-worker-timetable-1`) tidak ikut bootstrap — bertugas hanya `queue:work` antrian `timetable`.

## Akun Default Super-Admin

| Field    | Value             |
| -------- | ----------------- |
| Email    | deewahyu@upi.edu  |
| Password | Ddw9889##         |
| Role     | super-admin       |

Ganti password segera lewat UI setelah login pertama. Seeder tidak akan menimpa password yang sudah diubah karena `firstOrCreate` hanya set field saat baris baru dibuat.

## Pasang HTTPS (Let's Encrypt)

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d fetnet.techupi.id
```

Certbot akan auto-update file nginx host. Setelah sukses, buka blok HTTPS yang sudah disiapkan (komentar) di `docs/fetnet.conf` jika perlu manual override.

## Konfigurasi Domain & Reverse Proxy

- Container nginx expose port `8088` di host (lihat `docker-compose.yml`).
- Host nginx proxy_pass ke `http://127.0.0.1:8088` (lihat `docs/fetnet.conf`).
- Reverb (WebSocket) container expose port `8090` di host. Path `/app` di host nginx diteruskan ke `http://127.0.0.1:8090` dengan upgrade header.
- Laravel `bootstrap/app.php` set `trustProxies('*')` agar `X-Forwarded-Proto`/`X-Forwarded-Host` dari host nginx dihormati (penting setelah pasang TLS).

## Perintah Operasional

| Perintah                 | Fungsi                                              |
| ------------------------ | --------------------------------------------------- |
| `make up`                | Build + start semua container (auto bootstrap)      |
| `make down`              | Stop + hapus container & volume (DESTRUKTIF)        |
| `make stop`              | Stop tanpa menghapus                                |
| `make restart`           | Restart semua container                             |
| `make logs <container>`  | Tail log (mis. `make logs app`)                     |
| `make bash`              | Shell bash di container `app` (user www-data)       |
| `make artisan <cmd>`     | Jalankan `php artisan <cmd>` di container           |
| `make composer <cmd>`    | Jalankan `composer <cmd>` di container              |
| `make npm <cmd>`         | Jalankan `npm <cmd>` di container                   |

## Update Versi Aplikasi

```bash
cd /var/www/fetnet
git pull
make up   # rebuild image kalau Dockerfile/entrypoint berubah; auto migrate
```

Migration baru akan dijalankan otomatis saat container `app` restart (entrypoint).

## Troubleshooting

**`Error denied: requested access to the resource is denied` saat `make up`.**
Image `fetnet-app` belum di-tag. Pastikan `docker-compose.yml` field `image: fetnet-app` ada di service `app` (worker reuse image yang sama). Jalankan `make up` ulang.

**HTTP 500 setelah deploy.**
Cek `docker logs fetnet-app`. Penyebab umum:
- `.env` ada tapi `APP_KEY` kosong → manual `make artisan key:generate --force`
- Tabel hilang → cek `make artisan migrate:status`

**Tabel `sessions` not found.**
Bootstrap migrate gagal di-skip. Cek log: `docker logs fetnet-app | grep bootstrap`. Jalankan manual: `make artisan migrate --force`.

**Asset (CSS/JS) 404.**
`public/build/` belum di-generate. Jalankan: `make npm run build`.

**Login redirect loop / `419 Page Expired` di belakang reverse proxy.**
`trustProxies` sudah aktif. Pastikan host nginx forward `X-Forwarded-Proto $scheme` (sudah ada di `docs/fetnet.conf`).
