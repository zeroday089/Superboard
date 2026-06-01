# Commerce Intelligence AI

Commerce Intelligence AI is a production-grade SaaS blueprint for an AI-powered Shopify intelligence platform that acts as a virtual COO for e-commerce businesses.

The platform is intentionally designed as a decision engine rather than another analytics dashboard. It answers four operator questions:

1. What happened?
2. Why did it happen?
3. What should I do next?
4. What impact will that action have?

## What is included

| Deliverable | Location |
| --- | --- |
| Full PRD and product strategy | [`docs/product/prd.md`](docs/product/prd.md) |
| Complete system architecture and microservices | [`docs/architecture/system-architecture.md`](docs/architecture/system-architecture.md) |
| Event-driven architecture | [`docs/architecture/event-driven-architecture.md`](docs/architecture/event-driven-architecture.md) |
| Shopify app architecture | [`docs/architecture/shopify-app-architecture.md`](docs/architecture/shopify-app-architecture.md) |
| PostgreSQL schema | [`docs/database/postgres-schema.sql`](docs/database/postgres-schema.sql) |
| ClickHouse schema | [`docs/database/clickhouse-schema.sql`](docs/database/clickhouse-schema.sql) |
| ER diagrams | [`docs/diagrams/er-diagrams.md`](docs/diagrams/er-diagrams.md) |
| API specifications | [`docs/api/openapi.yaml`](docs/api/openapi.yaml) |
| AI agent, recommendation, and chat/RAG architecture | [`docs/ai/ai-architecture.md`](docs/ai/ai-architecture.md) |
| Data pipelines | [`docs/pipelines/data-pipelines.md`](docs/pipelines/data-pipelines.md) |
| Dashboard wireframes and UX/UI specs | [`docs/ux/dashboard-wireframes.md`](docs/ux/dashboard-wireframes.md) |
| MVP and production roadmaps | [`docs/roadmap/roadmap.md`](docs/roadmap/roadmap.md) |
| Scaling, security, infrastructure, and revenue model | [`docs/ops/production-plan.md`](docs/ops/production-plan.md) |
| Recommended monorepo folder structure | [`docs/architecture/folder-structure.md`](docs/architecture/folder-structure.md) |

## Target stack

- **Frontend:** Next.js, TypeScript, Tailwind CSS, ShadCN UI.
- **Backend:** Node.js, NestJS, REST and GraphQL edge APIs.
- **Data:** PostgreSQL for transactional state, ClickHouse for analytical events, Redis for queues/cache/rate limits.
- **AI:** Provider abstraction for OpenAI and Anthropic, plus deterministic analytical models for forecasting, anomaly detection, and recommendation scoring.
- **Infra:** Docker, Kubernetes, AWS, Terraform, GitHub Actions, observability through OpenTelemetry.

## Subscription model

Commerce Intelligence AI uses a freemium SaaS model with paid plans requested by the product brief:

| Plan | Monthly price | Ideal customer | Highlights |
| --- | ---: | --- | --- |
| Free | $0 | New Shopify stores | Limited connectors, 7-day history, basic daily brief, capped chat questions |
| Starter | $59 | Small stores validating growth | Shopify + GA4 + email, 90-day history, weekly recommendations |
| Growth | $99 | Scaling stores | Ads connectors, forecasting, heatmap intelligence, benchmark comparisons |
| Pro | Custom add-on tier | Advanced operators | Multi-store, advanced permissions, API access, priority syncs |
| Enterprise | Custom | Agencies and brands | SSO, custom SLAs, private benchmark cohorts, data residency |

## Differentiated moat

The benchmarking layer anonymously aggregates normalized metrics across similar stores by niche, revenue range, geography, AOV band, and lifecycle stage. This creates defensible industry intelligence that helps merchants understand whether performance changes are store-specific or market-wide.
