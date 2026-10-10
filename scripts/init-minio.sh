#!/bin/sh
set -eu

ENDPOINT="${MINIO_ENDPOINT:-http://minio:9000}"
ALIAS="local"
BUCKET="${LAUNDRY_PONDOK_BUCKET:-laundry-pondok}"
POLICY_NAME="laundry-pondok-rw"
POLICY_FILE="/tmp/laundry-pondok-rw.json"

require_env() {
  var_name="$1"
  eval "var_value=\${${var_name}:-}"
  if [ -z "${var_value}" ]; then
    echo "Missing required env: ${var_name}"
    echo "Add it to .env (see .env.example) then recreate minio-init."
    exit 1
  fi
}

require_env MINIO_ROOT_USER
require_env MINIO_ROOT_PASSWORD
require_env LAUNDRY_PONDOK_ACCESS_KEY
require_env LAUNDRY_PONDOK_SECRET_KEY
require_env LAUNDRY_PONDOK_BUCKET

echo "Waiting for MinIO at ${ENDPOINT} ..."
i=0
until mc alias set "${ALIAS}" "${ENDPOINT}" "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}" >/dev/null 2>&1; do
  i=$((i + 1))
  if [ "${i}" -ge 60 ]; then
    echo "MinIO did not become ready in time."
    exit 1
  fi
  sleep 2
done

echo "Creating bucket ${BUCKET} ..."
mc mb --ignore-existing "${ALIAS}/${BUCKET}"

cat > "${POLICY_FILE}" <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetBucketLocation", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${BUCKET}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts"
      ],
      "Resource": ["arn:aws:s3:::${BUCKET}/*"]
    }
  ]
}
EOF

if mc admin policy info "${ALIAS}" "${POLICY_NAME}" >/dev/null 2>&1; then
  mc admin policy remove "${ALIAS}" "${POLICY_NAME}" >/dev/null 2>&1 || true
fi
mc admin policy create "${ALIAS}" "${POLICY_NAME}" "${POLICY_FILE}"

if mc admin user info "${ALIAS}" "${LAUNDRY_PONDOK_ACCESS_KEY}" >/dev/null 2>&1; then
  mc admin user remove "${ALIAS}" "${LAUNDRY_PONDOK_ACCESS_KEY}"
fi

echo "Creating laundry-pondok application user ..."
mc admin user add "${ALIAS}" "${LAUNDRY_PONDOK_ACCESS_KEY}" "${LAUNDRY_PONDOK_SECRET_KEY}"
mc admin policy attach "${ALIAS}" "${POLICY_NAME}" --user "${LAUNDRY_PONDOK_ACCESS_KEY}"

echo "Init complete."
mc ls "${ALIAS}"
