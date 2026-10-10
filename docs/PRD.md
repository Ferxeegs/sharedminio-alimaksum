# Product Requirements Document — Shared MinIO

## 1. Ringkasan

**Nama sistem:** Shared MinIO  
**Konsumen:** tidak ada aplikasi yang terhubung  
**Status:** Aktif  

Shared MinIO adalah layanan object storage berbasis MinIO dan Docker Compose. Bucket dan kredensial aplikasi lain tidak lagi dibuat oleh stack ini.

## 2. Tujuan

1. Menyediakan object storage S3-compatible yang berdiri sendiri.
2. Menyediakan monitoring kapasitas dan availability (Prometheus/Grafana).

## 3. Ruang Lingkup

### Termasuk

- MinIO single node pada Docker Compose.
- Akses langsung ke S3 API (tanpa Nginx).
- Monitoring Prometheus + Grafana.
- Network Docker privat `sharedminio-alimaksum`.

### Tidak termasuk

- Bucket, user, atau policy untuk aplikasi lain.
- High availability / distributed MinIO.
- Reverse proxy Nginx di stack ini.
- Backup eksternal (belum ada media tujuan).

## 4. Acceptance

1. Stack Compose sehat.
2. Tidak ada bucket aplikasi yang terbuat otomatis.
3. Smoke test health lulus.
