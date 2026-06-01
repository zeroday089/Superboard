# Dashboard Wireframes and UX/UI Specifications

## 1. UX positioning

Commerce Intelligence AI should feel like a command center and AI COO, not a reporting dashboard. The first screen should prioritize decisions, risks, and expected impact before raw charts.

## 2. Design system

- Framework: Next.js, TypeScript, Tailwind CSS, ShadCN UI.
- Theme: executive, trustworthy, high-contrast data cards, clean SaaS layout.
- Primary navigation: Executive, Marketing, Product, Customer, Funnel, Heatmap, Forecasting, Benchmarks, AI Chat, Settings.
- Core components: metric cards, insight cards, recommendation cards, confidence badges, evidence drawers, chart panels, data freshness pills, benchmark percentile bars.

## 3. Global layout

```text
┌────────────────────────────────────────────────────────────────────────────┐
│ Store Switcher | Commerce Intelligence AI | Search/Ask AI | User/Profile   │
├───────────────┬────────────────────────────────────────────────────────────┤
│ Executive     │ Page title + date range + compare period + data freshness  │
│ Marketing     ├────────────────────────────────────────────────────────────┤
│ Product       │ AI priority strip: "3 actions can add $12.4k next 7 days"  │
│ Customer      ├────────────────────────────────────────────────────────────┤
│ Funnel        │ Main content module                                        │
│ Heatmap       │                                                            │
│ Forecasting   │                                                            │
│ Benchmarks    │                                                            │
│ AI Chat       │                                                            │
│ Settings      │                                                            │
└───────────────┴────────────────────────────────────────────────────────────┘
```

## 4. Executive Dashboard

Purpose: answer what happened, why, and what to do.

```text
┌────────────────────────────────────────────────────────────────────┐
│ Daily Business Brief                                                │
│ Revenue +12% | Profit +9% | Conversion -3% | Inventory risk: High   │
│ Why: Google Shopping conversions +25%, Product X 40% of profit      │
│ Action: Increase Campaign A budget 15% → expected +$50k next week   │
└────────────────────────────────────────────────────────────────────┘
┌──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
│ Revenue  │ Profit   │ ROAS     │ CAC      │ AOV      │ Conv Rate│
└──────────┴──────────┴──────────┴──────────┴──────────┴──────────┘
┌─────────────────────────────┬──────────────────────────────────────┐
│ Revenue trend + forecast     │ Root cause contribution waterfall     │
└─────────────────────────────┴──────────────────────────────────────┘
┌─────────────────────────────┬──────────────────────────────────────┐
│ Top recommendations          │ Benchmark percentile snapshot         │
└─────────────────────────────┴──────────────────────────────────────┘
```

Required cards:

- Revenue, profit, ROAS, CAC, AOV, conversion rate.
- Root cause cards.
- Forecast summary.
- Inventory risk summary.
- Benchmark comparison.
- Recommendation queue.

## 5. Marketing Intelligence

```text
┌────────────────────────────────────────────────────────────────────┐
│ Channel allocation recommendation                                  │
│ Move $2,000 from Meta prospecting to Google Shopping. Confidence 82%│
└────────────────────────────────────────────────────────────────────┘
┌──────────┬──────────┬──────────┬──────────┬──────────┐
│ Spend    │ Revenue  │ ROAS     │ CPA      │ CTR      │
└──────────┴──────────┴──────────┴──────────┴──────────┘
┌─────────────────────────────┬──────────────────────────────────────┐
│ Channel performance table    │ Campaign fatigue detector             │
└─────────────────────────────┴──────────────────────────────────────┘
```

Views:

- Meta Ads.
- Google Ads.
- Email performance.
- Creative fatigue.
- Budget allocator.
- Attribution caveats.

## 6. Product Intelligence

Views:

- Top products by revenue, profit, units, conversion, refund rate.
- Low performers.
- Inventory risk and stockout date.
- Overstock alerts.
- Price/discount opportunities.
- Product benchmark gaps where cohort allows.

```text
┌────────────────────────────────────────────────────────────────────┐
│ Inventory risk: Product Y stockout in 9 days; revenue at risk $8.2k │
└────────────────────────────────────────────────────────────────────┘
┌─────────────────────────────┬──────────────────────────────────────┐
│ Product leaderboard          │ Inventory forecast table              │
└─────────────────────────────┴──────────────────────────────────────┘
```

## 7. Customer Intelligence

Views:

- LTV by cohort.
- Repeat purchase probability.
- Churn risk segments.
- VIP customers.
- Support/refund impact on retention.
- Win-back recommendations.

## 8. Funnel Intelligence

Views:

- Traffic, product page views, add-to-cart, checkout, purchase.
- Drop-off by device, source, campaign, product, geography.
- Cart abandonment movement.
- Checkout friction alerts.

## 9. Heatmap Intelligence

Views:

- UX issue list ranked by revenue impact.
- Rage click clusters.
- Dead click clusters.
- Scroll-depth visualization.
- Session recording links.
- AI explanation and recommendation.

```text
┌────────────────────────────────────────────────────────────────────┐
│ UX Insight: 65% of mobile users never reach Add to Cart             │
│ Recommendation: Move Add to Cart above fold                         │
│ Expected conversion improvement: +8% | Confidence: 74%              │
└────────────────────────────────────────────────────────────────────┘
```

## 10. Forecasting Center

Tabs:

- Revenue forecast: 7/30/90-day trend with uncertainty bands.
- Inventory forecast: stockout calendar and reorder dates.
- Customer forecast: churn, repeat purchase, predicted LTV.

## 11. Benchmarking Center

Views:

- Cohort description without exposing members.
- Percentile bars for conversion, AOV, ROAS, CAC, repeat purchase, refund rate, stockout rate, email revenue share.
- Market movement vs store movement.
- Opportunity gaps with estimated impact.

## 12. AI Chat UX

```text
┌────────────────────────────────────────────────────────────────────┐
│ Ask your AI COO                                                     │
│ [Why did revenue drop this week?                                  ] │
├────────────────────────────────────────────────────────────────────┤
│ Answer: Revenue dropped 18%. The main drivers were...               │
│ Evidence table                                                      │
│ Chart: Revenue decomposition                                        │
│ Recommended actions                                                 │
│ Follow-ups: Show affected SKUs | Draft email campaign | Compare peers│
└────────────────────────────────────────────────────────────────────┘
```

Chat must support:

- Text response.
- Charts.
- Tables.
- Recommendation cards.
- Source/evidence drawer.
- Follow-up prompts.
- Data freshness label.
