# Recommended Monorepo Folder Structure

```text
commerce-intelligence-ai/
  apps/
    web/                         # Next.js merchant app
      app/
      components/
      lib/
      styles/
      tests/
    api/                         # NestJS API gateway
      src/
        modules/
          auth/
          billing/
          stores/
          connectors/
          metrics/
          insights/
          recommendations/
          chat/
          benchmarks/
        common/
        main.ts
      test/
    workers/                     # BullMQ/Kafka workers
      src/
        shopify-sync/
        ads-sync/
        analytics-sync/
        ai-jobs/
        forecasting/
        benchmarks/
    admin/                       # Internal operations console
  packages/
    config/                      # Shared lint/tsconfig/env config
    db/                          # Prisma/Drizzle migrations and clients
    clickhouse/                  # ClickHouse migrations/query helpers
    ui/                          # Shared ShadCN/Tailwind components
    domain/                      # Shared domain types and schemas
    metrics/                     # Semantic metrics definitions
    ai/                          # Prompt templates, tool contracts, evaluators
    connectors/                  # Shared OAuth/API clients
    security/                    # Auth, RBAC, encryption helpers
  infrastructure/
    docker/
    helm/
    terraform/
    github-actions/
  docs/
    api/
    architecture/
    ai/
    database/
    diagrams/
    ops/
    pipelines/
    product/
    roadmap/
    ux/
  scripts/
    seed-demo-store.ts
    replay-events.ts
    generate-openapi.ts
```

## Package boundaries

- `apps/web` must not query databases directly.
- `apps/api` owns tenant authorization, entitlement checks, and API composition.
- `apps/workers` owns long-running syncs, forecasting jobs, benchmark aggregation, and daily AI jobs.
- `packages/metrics` defines canonical metrics, dimensions, filters, and SQL builders.
- `packages/ai` defines prompts, schemas, tool manifests, evaluation datasets, and safety policies.
- `packages/connectors` contains provider clients with retry, rate limiting, and token refresh utilities.

## Environment files

Use separate environment templates:

- `.env.local.example` for local development.
- `.env.test.example` for integration tests.
- `.env.production.example` for deployment documentation.

Secrets must never be committed. Production secrets belong in AWS Secrets Manager or equivalent.
