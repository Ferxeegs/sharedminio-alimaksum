# Storage Schema — Shared MinIO

## 1. Bucket

`docker compose up` hanya menjalankan MinIO, Prometheus, dan Grafana. Tidak ada job yang membuat bucket.

Bucket yang masih ada di disk data lama tetap tersimpan di `MINIO_DATA_PATH` sampai dihapus manual dari Console atau `mc`.

## 2. Struktur Object Key

Bila bucket baru dibuat nanti, pola yang disarankan:

```text
{entity_type}/{year}/{month}/{entity_id}/{file_uuid}.{extension}
```

## 3. Penyimpanan URL

Simpan `bucket_name` + `object_key` di database aplikasi, bukan URL sementara.
