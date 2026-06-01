-- ClickHouse analytical schema for Commerce Intelligence AI.
-- Use MergeTree engines partitioned by month and ordered by tenant/time dimensions.

CREATE DATABASE IF NOT EXISTS commerce_intelligence;
USE commerce_intelligence;

CREATE TABLE IF NOT EXISTS fact_orders (
  store_id UUID,
  order_id UUID,
  customer_id UUID,
  processed_at DateTime64(3, 'UTC'),
  order_date Date,
  channel LowCardinality(String),
  source_name LowCardinality(String),
  currency_code FixedString(3),
  subtotal_minor Int64,
  discount_minor Int64,
  tax_minor Int64,
  shipping_minor Int64,
  total_minor Int64,
  refund_minor Int64,
  net_revenue_minor Int64,
  gross_profit_minor Nullable(Int64),
  item_count UInt32,
  is_first_order UInt8,
  country_code LowCardinality(String),
  device_category LowCardinality(String),
  ingested_at DateTime64(3, 'UTC') DEFAULT now64(3)
) ENGINE = MergeTree
PARTITION BY toYYYYMM(order_date)
ORDER BY (store_id, order_date, processed_at, order_id);

CREATE TABLE IF NOT EXISTS fact_order_line_items (
  store_id UUID,
  order_id UUID,
  line_item_id UUID,
  product_id UUID,
  variant_id UUID,
  order_date Date,
  quantity UInt32,
  unit_price_minor Int64,
  discount_minor Int64,
  total_minor Int64,
  cost_minor Nullable(Int64),
  gross_profit_minor Nullable(Int64),
  ingested_at DateTime64(3, 'UTC') DEFAULT now64(3)
) ENGINE = MergeTree
PARTITION BY toYYYYMM(order_date)
ORDER BY (store_id, order_date, product_id, variant_id, order_id);

CREATE TABLE IF NOT EXISTS fact_ad_metrics_daily (
  store_id UUID,
  ad_account_id UUID,
  campaign_id UUID,
  ad_set_id String,
  ad_id String,
  channel LowCardinality(String),
  campaign_type LowCardinality(String),
  metric_date Date,
  impressions UInt64,
  clicks UInt64,
  spend_minor Int64,
  conversions Float64,
  conversion_value_minor Int64,
  cpc_minor Float64,
  cpm_minor Float64,
  ctr Float64,
  cpa_minor Float64,
  roas Float64,
  frequency Nullable(Float64),
  ingested_at DateTime64(3, 'UTC') DEFAULT now64(3)
) ENGINE = SummingMergeTree
PARTITION BY toYYYYMM(metric_date)
ORDER BY (store_id, channel, metric_date, campaign_id, ad_set_id, ad_id);

CREATE TABLE IF NOT EXISTS fact_traffic_daily (
  store_id UUID,
  metric_date Date,
  source LowCardinality(String),
  medium LowCardinality(String),
  campaign String,
  device_category LowCardinality(String),
  country_code LowCardinality(String),
  sessions UInt64,
  users UInt64,
  new_users UInt64,
  engaged_sessions UInt64,
  bounce_rate Float64,
  add_to_carts UInt64,
  checkouts UInt64,
  purchases UInt64,
  revenue_minor Int64,
  ingested_at DateTime64(3, 'UTC') DEFAULT now64(3)
) ENGINE = SummingMergeTree
PARTITION BY toYYYYMM(metric_date)
ORDER BY (store_id, metric_date, source, medium, device_category, country_code);

CREATE TABLE IF NOT EXISTS fact_events (
  store_id UUID,
  event_time DateTime64(3, 'UTC'),
  event_date Date,
  anonymous_user_id String,
  customer_id Nullable(UUID),
  session_id String,
  event_name LowCardinality(String),
  page_url String,
  product_id Nullable(UUID),
  variant_id Nullable(UUID),
  device_category LowCardinality(String),
  source LowCardinality(String),
  medium LowCardinality(String),
  properties_json String,
  ingested_at DateTime64(3, 'UTC') DEFAULT now64(3)
) ENGINE = MergeTree
PARTITION BY toYYYYMM(event_date)
ORDER BY (store_id, event_date, event_name, session_id, event_time);

CREATE TABLE IF NOT EXISTS fact_heatmap_events (
  store_id UUID,
  event_date Date,
  page_url String,
  device_category LowCardinality(String),
  event_type LowCardinality(String),
  x_position Float64,
  y_position Float64,
  viewport_width UInt32,
  viewport_height UInt32,
  scroll_depth_percent Float64,
  session_id String,
  recording_url String,
  severity_score Float64,
  ingested_at DateTime64(3, 'UTC') DEFAULT now64(3)
) ENGINE = MergeTree
PARTITION BY toYYYYMM(event_date)
ORDER BY (store_id, event_date, page_url, device_category, event_type);

CREATE TABLE IF NOT EXISTS fact_email_metrics_daily (
  store_id UUID,
  connector LowCardinality(String),
  campaign_or_flow_id String,
  campaign_or_flow_name String,
  message_type LowCardinality(String),
  metric_date Date,
  sent UInt64,
  delivered UInt64,
  opens UInt64,
  clicks UInt64,
  unsubscribes UInt64,
  attributed_orders UInt64,
  attributed_revenue_minor Int64,
  ingested_at DateTime64(3, 'UTC') DEFAULT now64(3)
) ENGINE = SummingMergeTree
PARTITION BY toYYYYMM(metric_date)
ORDER BY (store_id, connector, metric_date, campaign_or_flow_id);

CREATE TABLE IF NOT EXISTS fact_support_tickets (
  store_id UUID,
  ticket_id String,
  connector LowCardinality(String),
  created_at DateTime64(3, 'UTC'),
  ticket_date Date,
  status LowCardinality(String),
  priority LowCardinality(String),
  category LowCardinality(String),
  sentiment_score Float64,
  first_response_minutes Nullable(UInt32),
  resolution_minutes Nullable(UInt32),
  refund_requested UInt8,
  order_id Nullable(UUID),
  customer_id Nullable(UUID),
  tags Array(String),
  ingested_at DateTime64(3, 'UTC') DEFAULT now64(3)
) ENGINE = ReplacingMergeTree(ingested_at)
PARTITION BY toYYYYMM(ticket_date)
ORDER BY (store_id, ticket_date, ticket_id);

CREATE TABLE IF NOT EXISTS metric_store_daily (
  store_id UUID,
  metric_date Date,
  revenue_minor Int64,
  gross_profit_minor Int64,
  orders UInt64,
  customers UInt64,
  new_customers UInt64,
  sessions UInt64,
  conversion_rate Float64,
  aov_minor Float64,
  cac_minor Float64,
  roas Float64,
  refund_rate Float64,
  repeat_purchase_rate Float64,
  email_revenue_share Float64,
  stockout_variant_count UInt64,
  updated_at DateTime64(3, 'UTC') DEFAULT now64(3)
) ENGINE = ReplacingMergeTree(updated_at)
PARTITION BY toYYYYMM(metric_date)
ORDER BY (store_id, metric_date);

CREATE TABLE IF NOT EXISTS benchmark_metrics_daily (
  cohort_key String,
  metric_date Date,
  metric_name LowCardinality(String),
  p10 Float64,
  p25 Float64,
  p50 Float64,
  p75 Float64,
  p90 Float64,
  average Float64,
  store_count UInt32,
  suppression_applied UInt8,
  updated_at DateTime64(3, 'UTC') DEFAULT now64(3)
) ENGINE = ReplacingMergeTree(updated_at)
PARTITION BY toYYYYMM(metric_date)
ORDER BY (cohort_key, metric_date, metric_name);

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_store_daily_orders
TO metric_store_daily
AS
SELECT
  store_id,
  order_date AS metric_date,
  sum(net_revenue_minor) AS revenue_minor,
  sum(ifNull(gross_profit_minor, 0)) AS gross_profit_minor,
  count() AS orders,
  uniqExact(customer_id) AS customers,
  sum(is_first_order) AS new_customers,
  0 AS sessions,
  0 AS conversion_rate,
  if(count() = 0, 0, sum(net_revenue_minor) / count()) AS aov_minor,
  0 AS cac_minor,
  0 AS roas,
  if(sum(total_minor) = 0, 0, sum(refund_minor) / sum(total_minor)) AS refund_rate,
  0 AS repeat_purchase_rate,
  0 AS email_revenue_share,
  0 AS stockout_variant_count,
  now64(3) AS updated_at
FROM fact_orders
GROUP BY store_id, order_date;
