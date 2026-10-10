# Deployment — Shared MinIO

## Prasyarat

- Ubuntu 24.04 LTS (atau setara).
- Akses sudo.
- Docker Engine dan Docker Compose plugin.
- Firewall yang membatasi akses port MinIO.

## Struktur

```text
# Repository / deploy path (contoh: /opt/sharedminio)
.
├── docker-compose.yml
├── .env
├── prometheus/
├── grafana/
└── scripts/

# Persistent object data (di luar repo)
/srv/sharedminio/
└── data/
```

Atur path data melalui `MINIO_DATA_PATH` di `.env`:

- lokal: `./data`
- production: `/srv/sharedminio/data`

## Urutan Deployment

1. Audit kapasitas disk.
2. Instal Docker Engine dan Compose.
3. Buat direktori data persisten (`/srv/sharedminio/data`).
4. Clone repo ke `/opt/sharedminio`, salin `.env.example` → `.env`.
5. Jalankan stack: `docker compose up -d`.
6. Verifikasi Prometheus dan Grafana.
7. Uji health (`./scripts/smoke-test.sh`).

## Perintah

```bash
cd /opt/sharedminio
cp .env.example .env
# edit secret
mkdir -p /srv/sharedminio/data
# set MINIO_DATA_PATH=/srv/sharedminio/data pada production
docker compose up -d
./scripts/smoke-test.sh
```

## Guardrail

- Jangan menjalankan `docker compose down -v` pada production.
- Jangan menghapus `/srv/sharedminio/data` saat update container.
- Jangan membagikan root credential ke aplikasi lain.
- Batasi port `9000`/`9001` lewat firewall (bukan internet publik).
- Tidak ada Nginx; S3 API MinIO diakses langsung.
