#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT_DIR}"

if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  set -a
  # shellcheck source=/dev/null
  source .env
  set +a
fi

ENDPOINT="${SMOKE_ENDPOINT:-http://127.0.0.1:${MINIO_API_PORT:-9000}}"

echo "1) MinIO live health"
curl -fsS "${ENDPOINT}/minio/health/live" >/dev/null
echo "   ok"

echo "Smoke test passed."
