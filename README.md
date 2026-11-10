# SMS-World

A responsive public directory and inbox for SMS numbers and messages whose providers explicitly authorize public display. The interface is inspired by the country/number/inbox flow of Receive-SMSS, without copying its branding or claiming access to its number inventory.

## Safety and source requirements

- A phone number appearing in a GitHub repository is not proof that it is active, SMS-capable, or authorized for reuse.
- GitHub discovery is for cataloguing integration projects and documented resources. Do not scrape private inboxes or harvest third-party OTP messages.
- Only provider APIs with explicit authorization for message ingestion and public display may be enabled.
- A number may be marked `verified` only after an actual test SMS has been received and recorded by an authorized provider. Untested/demo numbers must remain `pending`.
- Do not use shared public inboxes for personal accounts, sensitive verification, or confidential messages.
- No real number providers are connected in this initial MVP. No live receive test has yet been performed.

## Stack

Cloudflare Workers + D1 + static assets.

## Current MVP

- Responsive country/number directory with search and status filters.
- Public inbox view for approved, verified numbers.
- D1 schema for sources, numbers, and messages.
- Ingestion API protected by a Worker secret and source authorization flags.
- Admin source-list API protected by a Worker secret.
- Health endpoint and 24-hour message retention cleanup.
- GitHub catalogues/API integrations are intentionally not auto-enabled; each source needs review and authorization.

## Setup

1. Install Node.js and run `npm install`.
2. Create D1: `npm run db:create`.
3. Copy the generated database ID into `wrangler.toml`.
4. Apply schema: `npm run db:migrate`.
5. Set secrets: `npx wrangler secret put ADMIN_TOKEN` and `npx wrangler secret put INGEST_TOKEN`.
6. Run locally: `npm run dev`.
7. Deploy: `npm run deploy`.

## API

- `GET /api/health` — health check.
- `GET /api/numbers` — approved public directory.
- `GET /api/numbers/:id/messages` — inbox for a verified number, public messages only.
- `GET /api/admin/sources` — source metadata; requires `Authorization: Bearer ADMIN_TOKEN`.
- `POST /api/ingest` — authorized provider ingestion; requires `Authorization: Bearer INGEST_TOKEN`.

The ingestion endpoint accepts only enabled sources with both `authorization_confirmed=1` and `public_display_allowed=1`. The provider must create source and number records in D1 after review. This initial repository does not claim that any real number source is connected.

## Retention

The scheduled Worker deletes messages older than 24 hours. Review local privacy law and provider requirements before public launch.
