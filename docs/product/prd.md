# Full PRD: Commerce Intelligence AI

## 1. Product overview

Commerce Intelligence AI is an AI-powered Shopify analytics and decision engine. The platform acts as a virtual COO for Shopify merchants by collecting operational, marketing, customer, product, support, behavior, and website data into a unified intelligence layer.

The product must not be framed as a passive dashboard. Every surface should explain business movement, diagnose causes, recommend actions, and quantify likely impact.

## 2. Product principles

1. **Decision-first:** Every chart should lead to an insight, recommendation, or diagnostic path.
2. **Causal reasoning over metric display:** The platform should connect metrics across inventory, traffic, ads, UX, support, and customer behavior.
3. **Operator trust:** Every AI answer must include source data, confidence, assumptions, and freshness.
4. **Actionability:** Recommendations must include owner, priority, estimated impact, confidence, and expected time horizon.
5. **Multi-tenant by design:** Every data model, API, job, and cache key must be tenant isolated by `store_id` and organization context.
6. **Benchmark moat:** Anonymized benchmark cohorts should turn aggregate industry intelligence into a compounding data advantage.

## 3. Users and personas

| Persona | Goals | Pain points | Core workflows |
| --- | --- | --- | --- |
| Founder/operator | Know what is happening and what to do next | Data scattered across Shopify, ads, email, GA4, and support tools | Daily brief, root-cause analysis, recommendations |
| Growth marketer | Allocate budget and optimize channels | Cannot connect channel changes to profit, inventory, or LTV | Marketing intelligence, creative fatigue, ROAS/CAC, benchmark comparisons |
| E-commerce manager | Manage inventory, product performance, pricing | Stockouts, overstocks, slow movers, unclear product profitability | Product intelligence, inventory forecasts, reorder recommendations |
| Customer retention lead | Increase repeat purchase and reduce churn | Segmentation and churn insights are disconnected from product and support data | Customer intelligence, VIP/churn cohorts, win-back campaigns |
| Agency admin | Manage many stores | Needs consistent reporting and prioritized actions across clients | Multi-store portfolio, role permissions, exports, benchmarking |

## 4. Primary jobs to be done

- When I open the app in the morning, I want a business brief so I know the most important changes and actions.
- When revenue changes, I want to understand the root causes across traffic, ads, product availability, price, conversion, refunds, and support.
- When inventory is at risk, I want reorder dates and expected revenue-at-risk.
- When a campaign changes, I want to know whether the cause is spend, CTR, CPC, conversion rate, AOV, creative fatigue, or tracking quality.
- When conversion drops, I want heatmap, funnel, page speed, and session friction evidence.
- When I ask a business question in natural language, I want a live answer with charts, tables, and actions.
- When my metrics change, I want to know if it is just my store or an industry-wide movement among similar stores.

## 5. Data sources

### Shopify

Orders, products, variants, inventory levels, customers, collections, discounts, fulfillment, refunds, returns, transactions, shop metadata, and webhooks.

### Paid media

- Meta/Facebook Ads: campaigns, ad sets, ads, spend, impressions, clicks, CTR, CPM, CPC, conversions, CPA, ROAS, creative metadata.
- Google Ads: campaigns, search ads, shopping ads, Performance Max, assets, keywords, search terms, CPC, ROAS, conversions.

### Analytics and behavior

- GA4: sessions, users, traffic sources, events, funnels, journeys, device, geography.
- Microsoft Clarity: heatmaps, scroll maps, session recordings, rage clicks, dead clicks, excessive scrolling, JavaScript errors when available.
- Website analytics: page performance, Core Web Vitals, product page performance, funnel drop-offs.

### Email platforms

Klaviyo and Mailchimp metrics: campaigns, flows/automations, subscribers, unsubscribes, open rate, click rate, conversion attribution, revenue.

### Support

Zendesk and Gorgias metrics: tickets, tags, sentiment, refund requests, complaint categories, first response time, resolution time.

## 6. Core product modules

### 6.1 Daily Business Brief

Generated every morning per store and time zone.

Required sections:

1. Executive snapshot: revenue, profit, orders, AOV, conversion, ROAS, CAC.
2. Key movement: what increased or decreased materially.
3. Drivers: ranked causal contributors with supporting metrics.
4. Risks: inventory, conversion, campaigns, support, margin, fulfillment.
5. Recommended actions: top three actions with expected impact and confidence.
6. Benchmark context: whether the store is outperforming or underperforming similar stores.

### 6.2 Root Cause Analysis

Automatically detects and explains:

- Revenue drops and spikes.
- Conversion rate changes.
- Traffic source changes.
- AOV changes.
- Cart and checkout abandonment changes.
- Product mix shifts.
- Inventory constraints.
- Refund/return spikes.
- Support complaint spikes.

Root-cause cards must show contribution percentages, supporting evidence, confidence, and recommended next steps.

### 6.3 Predictive analytics

Forecasts required:

- Revenue: 7-day, 30-day, 90-day forecasts with uncertainty bands.
- Inventory: stockout date, reorder date, inventory risk, lost revenue estimate.
- Customer: churn probability, repeat purchase probability, predicted LTV, VIP segment likelihood.

### 6.4 AI recommendation engine

Recommendation categories:

- Marketing: budget allocation, ad optimization, creative fatigue, channel mix.
- Inventory: restock suggestions, overstock alerts, reorder quantity, revenue-at-risk.
- Pricing: price increase opportunities, discount optimization, margin protection.
- Product: winning products, losing products, bundling opportunities.
- Customer retention: VIP segmentation, win-back campaigns, post-purchase flows.
- UX/heatmap: move elements, simplify checkout, fix dead-click areas, reduce page load issues.

Each recommendation must include confidence score, reasoning, expected revenue impact, effort, risk, required integration, expiration date, and measurable success criteria.

### 6.5 AI chat assistant

The chat assistant supports natural-language questions such as:

- Why did revenue drop?
- Which campaign performs best?
- What products should I restock?
- Which customers are likely to churn?
- Show top products this month.
- Why is conversion rate declining?
- Am I behind similar stores this week?

Responses may include text, charts, tables, citations to internal data, and action recommendations.

### 6.6 Heatmap intelligence

The system analyzes Clarity heatmaps, scroll maps, and sessions to detect:

- Rage clicks.
- Dead clicks.
- UX problems.
- Checkout friction.
- Product page attention gaps.
- Add-to-cart visibility problems.
- Scroll depth bottlenecks.

Example insight: "65% of mobile users never reach the add-to-cart section. Move add-to-cart above the fold. Expected conversion improvement: +8%."

### 6.7 Benchmarking layer

Benchmarking compares stores anonymously against similar merchants by:

- Product niche.
- Revenue range.
- Geography.
- AOV band.
- Store maturity.
- Traffic mix.
- Catalog size.
- Paid media intensity.

Benchmark outputs:

- Percentile ranking by conversion rate, AOV, ROAS, CAC, repeat purchase rate, refund rate, email revenue share, page speed, stockout rate.
- Industry movement alerts, such as "Your revenue dropped 8%, but peer stores in your cohort dropped 6%; likely market-wide demand softness."
- Opportunity gaps, such as "Your email revenue share is in the 35th percentile; peers generate 18% more revenue from flows."

Privacy requirements:

- Never expose individual store data.
- Require minimum cohort size before showing comparisons.
- Apply k-anonymity thresholds and suppression rules.
- Aggregate only normalized metrics.
- Exclude stores from benchmark cohorts if contractually required.

## 7. Subscription plans

| Plan | Price | Limits | Included modules |
| --- | ---: | --- | --- |
| Free | $0/month | 1 store, Shopify only, 7-day data history, 5 AI questions/month, daily sync | Basic dashboard, basic daily brief, limited top products |
| Starter | $59/month | 1 store, 90-day history, 100 AI questions/month, daily sync | Shopify, GA4, Klaviyo/Mailchimp, executive dashboard, weekly recommendations |
| Growth | $99/month | 2 stores, 24-month history, 500 AI questions/month, 4-hour sync | Meta Ads, Google Ads, forecasting, heatmap intelligence, benchmark layer |
| Pro | Custom | 10 stores, API access, hourly sync, advanced roles | Multi-store portfolio, advanced recommendations, custom reports, priority support |
| Enterprise | Custom | Unlimited negotiated usage, SSO, custom data residency | Private benchmark cohorts, SLA, dedicated CSM, custom connectors |

## 8. Success metrics

| Area | Metric | Target |
| --- | --- | --- |
| Activation | Store connects Shopify and one marketing source | 60% within first session |
| Insight value | Users save or accept at least one recommendation | 35% within first 14 days |
| Retention | Weekly active stores | 55%+ for Growth plan |
| Monetization | Free-to-paid conversion | 8-12% |
| Benchmark moat | Stores opted into anonymous benchmarks | 70%+ |
| Trust | AI answer thumbs-up rate | 80%+ |
| Business impact | Recommendations with measured positive impact | 50%+ of executed actions |

## 9. Non-goals for MVP

- Automatically changing ad budgets without approval.
- Replacing accounting systems.
- Building a full BI tool with arbitrary SQL for all users.
- Providing legal, tax, or financial advice.
- Exposing raw benchmark member data.

## 10. Acceptance criteria

- A merchant can install the Shopify app and complete OAuth.
- The system backfills Shopify orders, products, variants, customers, inventory, refunds, and discounts.
- The merchant can connect GA4, Meta Ads, Google Ads, and at least one email source in Growth plan.
- Daily Business Brief runs per store time zone.
- Root-cause analysis works for revenue, conversion, AOV, traffic, and inventory shifts.
- Chat can answer governed analytical questions using live tenant data and source citations.
- Recommendations show confidence, reasoning, expected impact, and status.
- Benchmarking only displays cohorts that meet minimum privacy thresholds.
