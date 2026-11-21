# Public entry point: one HTTPS domain for the UI, the API (incl. WebSockets) and recordings.
FROM nginx:1.30.7-alpine@sha256:caf4e1e032a20f9c3c5e28fc7f25ffd768ad8677b4975c54193075997b3a97e3

# Use the container's DNS resolver (Railway's IPv6 private DNS) so *.railway.internal resolves.
ENV NGINX_ENTRYPOINT_LOCAL_RESOLVERS=1 \
    NGINX_ENVSUBST_FILTER="^(PORT|DOGRAH_API_HOST|DOGRAH_UI_HOST|MINIO_HOST|NGINX_LOCAL_RESOLVERS)$"
COPY 05-defaults.envsh /docker-entrypoint.d/05-defaults.envsh
COPY templates/default.conf.template /etc/nginx/templates/default.conf.template
RUN chmod 755 /docker-entrypoint.d/05-defaults.envsh && rm /etc/nginx/conf.d/default.conf

EXPOSE 8080
