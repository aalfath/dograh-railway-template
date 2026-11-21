#!/bin/sh
set -e
# Railway volumes start with lost+found, which MinIO would try to list as a bucket.
[ -d /data/lost+found ] && rmdir /data/lost+found 2>/dev/null || true

minio server /data --address ":9000" &
pid=$!
trap 'kill -TERM "$pid" 2>/dev/null; wait "$pid"; exit 0' TERM INT

# Create Dograh's private bucket once MinIO answers (an existing bucket is fine).
bucket="${DOGRAH_BUCKET:-voice-audio}"
i=0
until curl -fsS -o /dev/null http://127.0.0.1:9000/minio/health/live; do
  i=$((i+1)); [ "$i" -gt 60 ] && break; sleep 1
done
code=$(curl -s -o /dev/null -w '%{http_code}' -X PUT \
  --aws-sigv4 "aws:amz:us-east-1:s3" --user "${MINIO_ROOT_USER}:${MINIO_ROOT_PASSWORD}" \
  "http://127.0.0.1:9000/${bucket}" || true)
case "$code" in
  200) echo "dograh-minio: created bucket ${bucket}" ;;
  409) echo "dograh-minio: bucket ${bucket} already exists" ;;
  *)   echo "dograh-minio: bucket ${bucket} check returned HTTP ${code}" ;;
esac

wait "$pid"
