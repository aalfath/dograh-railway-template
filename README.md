[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/dograh-1?utm_medium=integration&utm_source=button&utm_campaign=dograh)

# Dograh on Railway

A Railway template for [Dograh](https://github.com/dograh-hq/dograh), the open-source voice AI platform: build voice agents in a visual workflow editor and run them in the browser (WebRTC) or over a phone line, with your own LLM, speech-to-text and text-to-speech keys.

**Version:** Dograh 1.51.0 (`dograhai/dograh-api:1.51.0` and `dograhai/dograh-ui:1.51.0`, both pinned by digest in the Dockerfiles).

## What it deploys

| Service | Source | Purpose |
| --- | --- | --- |
| `dograh` | `gateway/` (nginx 1.30.7) | The only public service. One HTTPS domain: `/` → UI, `/api/v1/` → API (with WebSockets), `/voice-audio/` → private object storage for presigned uploads and downloads. Health check `/healthz`. |
| `dograh-api` | `api/` | FastAPI backend, ARQ worker and campaign orchestrator. Runs database migrations on start. Health check `/api/v1/health`. |
| `dograh-ui` | `ui/` | Next.js web app. Private only. |
| `minio` | `minio/` | S3-compatible storage for recordings, transcripts and knowledge-base files, on a volume at `/data`. Private bucket `voice-audio`, no web console. |
| `Postgres` | Railway Postgres | Main database (pgvector is used for knowledge-base search). |
| `Redis` | Railway Redis | Queue and cache. |

All app services build from this repo, so deployers get an "update available" notice when `main` changes.

## Variables

Nothing to fill in at deploy time. Everything is derived by Railway:

- `dograh-api`: `DATABASE_URL` and `REDIS_URL` from the databases; `OSS_JWT_SECRET` generated (64 characters); `PUBLIC_BASE_URL`, `UI_APP_URL`, `S3_ENDPOINT_URL` and `PUBLIC_HOST` from the gateway's public domain; storage keys from `minio`; `ENABLE_SIGNUP=true`.
- `dograh-ui`: `BACKEND_URL` points at the API over the private network.
- `dograh`: private hostnames of the API, UI and MinIO.
- `minio`: `MINIO_ROOT_USER=dograh`, `MINIO_ROOT_PASSWORD` generated (32 characters).

## First start

Open the public URL and create an account: the first account is yours. Then set `ENABLE_SIGNUP=false` on `dograh-api` if nobody else should be able to sign up, and add your model and telephony keys in the Dograh UI.

## Notes and optional features

- **Telephony** (Twilio, Vonage, Plivo, Telnyx and others): configure it in the UI. Provider webhooks use the public domain from `PUBLIC_BASE_URL`. If you add a custom domain, update `PUBLIC_BASE_URL`, `UI_APP_URL`, `S3_ENDPOINT_URL` and `PUBLIC_HOST` on `dograh-api`.
- **TURN:** Railway has no public UDP, so the bundled coturn server is not deployed. Browser calls use public STUN, which works for most networks. To use your own TURN server, set `ENABLE_COTURN=true`, `TURN_HOST` and `TURN_SECRET` on `dograh-api`.
- **External S3:** to use AWS S3 instead of the bundled MinIO, change `S3_ENDPOINT_URL`, `S3_BUCKET`, `S3_REGION`, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` on `dograh-api`.
- Telemetry is turned off in this template (`ENABLE_TELEMETRY=false`).

## Wrapper changes against the official images

- `api/`: uvicorn listens on all IPv4 and IPv6 addresses (Railway's private network is IPv6), and botocore's `Expect: 100-continue` header is dropped for uploads through the gateway.
- `ui/`: Next.js listens dual-stack on port 3010.
- `minio/`: creates the private `voice-audio` bucket on first start and turns off the web console.

## Updates

Each release bumps the pinned images in `api/`, `ui/` (and `minio/` or `gateway/` when needed) on `main`, with an entry in [CHANGELOG.md](CHANGELOG.md). Railway then shows everyone who deployed the template an "update available" notice, and you choose when to apply it. Read the changelog first: breaking changes are listed at the top of each entry. Database migrations run automatically when the API starts.

## License

Dograh is licensed BSD-2-Clause by its authors. This repo only packages the official images for Railway.
