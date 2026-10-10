# Security — Shared MinIO

## Prinsip

- Least privilege.
- Deny by default.
- Secret tidak berada di Git.
- Console hanya melalui VPN/jaringan internal.
- Prefer TLS di jaringan produksi bila tersedia (gateway/VPN); stack ini mengekspos MinIO langsung tanpa Nginx.

## Kredensial

- Root credential hanya untuk administrator.
- Tidak ada user aplikasi yang dibuat oleh stack ini.
- Simpan secret di `.env` dengan permission ketat atau secret manager.

## Network

- S3 API MinIO ada di port `MINIO_API_PORT` (default 9000) pada host.
- Service hanya berada di network Docker `sharedminio-alimaksum`.
- Port MinIO tidak dibuka ke internet publik.
- Console (`MINIO_CONSOLE_PORT`) dibatasi VPN/internal.
- Firewall host hanya membuka port yang diperlukan.

## Incident Credential Leak

1. Ganti root password.
2. Restart service MinIO.
3. Tinjau audit log dan object yang berubah.
4. Dokumentasikan insiden.
