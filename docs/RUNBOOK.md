# Operational Runbook — Shared MinIO

## MinIO Tidak Dapat Diakses

1. Periksa jaringan/firewall ke host MinIO.
2. Periksa `docker compose ps` di root deploy (`/opt/sharedminio` atau path setara).
3. Periksa log MinIO (`docker compose logs minio`).
4. Periksa kapasitas disk dan inode (`MINIO_DATA_PATH`, default production `/srv/sharedminio/data`).
5. Restart hanya service yang diperlukan (`docker compose restart minio`).
6. Catat waktu dan penyebab insiden.

## Disk Hampir Penuh

1. Hentikan pertumbuhan log yang tidak terkendali.
2. Identifikasi konsumsi Docker, Prometheus, dan MinIO.
3. Jangan menghapus object production secara manual tanpa verifikasi.
4. Tambah kapasitas atau pindahkan data.
5. Validasi service setelah tindakan.

## Root Credential Bocor

1. Ganti `MINIO_ROOT_PASSWORD`.
2. Recreate service MinIO.
3. Audit log.
4. Tinjau object yang dibuat, diubah, atau dihapus.

## Upload Gagal

1. Periksa masa berlaku presigned URL.
2. Periksa ukuran file, MIME, dan konektivitas ke `:9000`.
3. Periksa apakah bucket tujuan ada.

## File Tidak Ditemukan

1. Verifikasi bucket dan object key.
2. Jalankan HEAD object.
3. Periksa apakah object sebelumnya dihapus.
4. Periksa log.
5. Karena backup belum tersedia, eskalasi sebagai potensi kehilangan data.
