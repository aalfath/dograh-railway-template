# Dograh API (FastAPI + ARQ worker + campaign orchestrator), official image pinned by version and digest.
FROM dograhai/dograh-api:1.51.0@sha256:715398c8376f8b6f04e46900d685693019fd3e016646c5df933358eb7d341fe0

USER root
# Railway's private network is IPv6: make uvicorn listen on all IPv4 and IPv6 addresses
# (an empty host) instead of 0.0.0.0 only.
RUN sed -i "s/--host 0\.0\.0\.0/--host ''/" /app/scripts/start_services_docker.sh \
 && grep -q -- "--host ''" /app/scripts/start_services_docker.sh
# boto3 sends "Expect: 100-continue" on larger uploads, which the HTTPS edge in front of
# the bundled MinIO does not answer; drop that header (loaded via PYTHONPATH=/app).
COPY --chown=dograh:dograh sitecustomize.py /app/sitecustomize.py
USER dograh

# Fixed settings for this template (Railway variables still override them).
ENV ENVIRONMENT=production \
    LOG_LEVEL=INFO \
    DEPLOYMENT_MODE=oss \
    AUTH_PROVIDER=local \
    FASTAPI_WORKERS=1 \
    ARQ_WORKERS=1 \
    UVICORN_BASE_PORT=8000 \
    ENABLE_AWS_S3=true \
    S3_BUCKET=voice-audio \
    S3_REGION=us-east-1 \
    S3_SIGNATURE_VERSION=s3v4 \
    S3_ADDRESSING_STYLE=path \
    FORWARDED_ALLOW_IPS=* \
    ENABLE_TELEMETRY=false

EXPOSE 8000
# Runs migrations (alembic upgrade head), then the API, ARQ worker and background services.
CMD ["./scripts/start_services_docker.sh"]
