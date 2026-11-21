# Object storage for call recordings, transcripts and uploads.
# Dograh's own MinIO build (upstream MinIO no longer publishes images), pinned by version and digest.
FROM dograhai/minio:2026.09.22@sha256:aa0a8b9f55b0ca5ec938eaced3849b52a18b96c36f26b0abf8fc6d3defad28db

# No web console: only the S3 API is used, and only through the gateway or the private network.
ENV MINIO_BROWSER=off
COPY start.sh /usr/local/bin/dograh-minio-start.sh
RUN chmod 755 /usr/local/bin/dograh-minio-start.sh

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/dograh-minio-start.sh"]
