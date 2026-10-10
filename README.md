# Shared MinIO

Object storage berbasis MinIO. Stack: Docker Compose, Prometheus, dan Grafana. Stack ini berdiri sendiri di network Docker `sharedminio-alimaksum` dan tidak membuat bucket atau user untuk aplikasi lain.

## Struktur

```text
.
├── docker-compose.yml
├── .env.example
├── prometheus/
├── grafana/
├── scripts/
└── docs/
```

Di server production, clone repo ke `/opt/sharedminio` (atau path setara). Data object tetap di `/srv/sharedminio/data` melalui `MINIO_DATA_PATH`.

## Quick start (lokal)

```bash
cp .env.example .env
# edit password di .env
docker compose up -d
./scripts/smoke-test.sh
```

- S3 API: `http://127.0.0.1:9000`
- MinIO Console: `http://127.0.0.1:9001` — login pakai `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD`
- Grafana: `http://127.0.0.1:3030` (atur `GRAFANA_PORT` di `.env`)

Tidak ada bucket aplikasi yang dibuat otomatis. Bucket baru dibuat manual lewat Console atau `mc` bila diperlukan.

## Dokumen

- `docs/PRD.md`
- `docs/ARCHITECTURE.md`
- `docs/SCHEMA.md`
- `docs/SECURITY.md`
- `docs/DEPLOYMENT.md`
- `docs/MONITORING.md`
- `docs/BACKUP-RESTORE.md`
- `docs/RUNBOOK.md`
