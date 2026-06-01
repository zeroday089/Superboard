# MVP and Production Roadmap

## 1. MVP objective

Launch a trustworthy AI COO for Shopify merchants that connects Shopify, produces a useful Daily Business Brief, explains revenue changes, provides product/inventory intelligence, and supports basic AI chat over live store data.

## 2. MVP scope: 12 weeks

### Phase 1: Foundation, weeks 1-2

- Monorepo setup with Next.js, NestJS, shared packages, Docker Compose.
- PostgreSQL and ClickHouse schemas.
- Identity, organizations, stores, roles.
- Shopify OAuth and embedded app shell.
- Billing entitlements for Free, Starter, and Growth.

### Phase 2: Shopify data, weeks 3-4

- Shopify backfill for products, variants, inventory, customers, orders, refunds, discounts.
- Webhooks for orders, refunds, products, inventory, customers, uninstall.
- Data freshness and sync status UI.
- Executive metric API.

### Phase 3: Intelligence MVP, weeks 5-7

- Revenue, profit, orders, AOV, conversion, top products.
- Revenue root-cause decomposition.
- Inventory stockout forecast.
- Daily Business Brief generation.
- Recommendation lifecycle: new, accepted, dismissed, completed.

### Phase 4: AI chat, weeks 8-9

- Chat threads and messages.
- Governed metric tools.
- Evidence bundle generation.
- LLM provider abstraction for OpenAI and Anthropic.
- Numeric verifier and response citations.

### Phase 5: Paid integrations, weeks 10-11

- GA4 connector.
- Meta Ads connector.
- Google Ads connector.
- Klaviyo or Mailchimp connector.
- Marketing intelligence dashboard.

### Phase 6: Launch readiness, week 12

- Security review.
- Observability dashboards.
- Shopify App Store review assets.
- Demo data and onboarding flows.
- Beta customer feedback loop.

## 3. MVP deliverables

- Embedded Shopify app.
- Executive Dashboard.
- Product Intelligence.
- Basic Marketing Intelligence.
- Daily Business Brief.
- Root-cause analysis for revenue/conversion/AOV/traffic.
- Inventory forecasting.
- AI chat with governed tool access.
- Free, Starter $59, and Growth $99 plan gates.

## 4. Production roadmap

### Quarter 1 after MVP

- Microsoft Clarity heatmap intelligence.
- Zendesk and Gorgias support connectors.
- Advanced customer churn/LTV models.
- Benchmarking layer private beta.
- Slack/email daily brief delivery.

### Quarter 2

- Benchmarking generally available.
- Cohort percentile dashboards.
- Recommendation impact tracking.
- Experiment tracking for accepted actions.
- Agency multi-store portfolio.
- Advanced roles and permissions.

### Quarter 3

- Autonomous draft actions with approval: discount drafts, campaign budget draft recommendations, email segment drafts.
- Advanced attribution and contribution modeling.
- Custom KPI builder.
- API access for Pro plan.
- Enterprise SSO and audit exports.

### Quarter 4

- Private benchmark cohorts for enterprise and agencies.
- Multi-region data residency.
- Forecast model marketplace.
- Automated weekly board report.
- Partner ecosystem integrations.

## 5. Implementation milestones

| Milestone | Exit criteria |
| --- | --- |
| Installable app | Shopify OAuth works and store is created |
| Data foundation | Orders/products/customers/inventory backfilled and reconciled |
| First insight | Daily brief generated with real metrics |
| First recommendation | Recommendation includes confidence, reasoning, and impact |
| First chat answer | Chat answers a metric question with evidence and no hallucinated numbers |
| First forecast | Revenue and inventory forecasts are visible |
| First paid upgrade | Plan limits and billing are enforced |
| First benchmark | Anonymous cohort comparison passes suppression rules |
