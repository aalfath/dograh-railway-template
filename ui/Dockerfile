# Dograh UI (Next.js), official image pinned by version and digest.
FROM dograhai/dograh-ui:1.51.0@sha256:ec16ad0fb89f23bb7732e5b9a695cbde8f34d27841d39e4d2d63676af4bedfb9

ENV NODE_ENV=oss \
    ENABLE_TELEMETRY=false \
    NEXT_TELEMETRY_DISABLED=1

EXPOSE 3010
# Listen dual-stack (Railway's private network is IPv6) on 3010.
CMD ["sh", "-c", "HOSTNAME=:: PORT=3010 exec node server.js"]
