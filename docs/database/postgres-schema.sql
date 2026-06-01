-- PostgreSQL transactional schema for Commerce Intelligence AI.
-- All tenant-owned records are scoped by organization_id and/or store_id.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;

CREATE TYPE user_role AS ENUM ('owner', 'admin', 'analyst', 'marketer', 'inventory_manager', 'read_only', 'agency_admin');
CREATE TYPE subscription_plan AS ENUM ('free', 'starter', 'growth', 'pro', 'enterprise');
CREATE TYPE connector_type AS ENUM ('shopify', 'meta_ads', 'google_ads', 'ga4', 'microsoft_clarity', 'klaviyo', 'mailchimp', 'zendesk', 'gorgias', 'website');
CREATE TYPE sync_status AS ENUM ('pending', 'running', 'succeeded', 'failed', 'paused', 'reauth_required');
CREATE TYPE recommendation_status AS ENUM ('new', 'accepted', 'dismissed', 'in_progress', 'completed', 'expired');
CREATE TYPE insight_type AS ENUM ('daily_brief', 'root_cause', 'forecast', 'benchmark', 'heatmap', 'marketing', 'inventory', 'customer', 'product', 'pricing');

CREATE TABLE organizations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  billing_email TEXT,
  benchmark_opt_in BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email CITEXT NOT NULL UNIQUE,
  name TEXT,
  avatar_url TEXT,
  password_hash TEXT,
  last_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE organization_memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role user_role NOT NULL DEFAULT 'read_only',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (organization_id, user_id)
);

CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  plan subscription_plan NOT NULL DEFAULT 'free',
  billing_provider TEXT NOT NULL DEFAULT 'shopify',
  billing_provider_subscription_id TEXT,
  status TEXT NOT NULL DEFAULT 'active',
  current_period_start TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  ai_question_limit INTEGER NOT NULL DEFAULT 5,
  connected_store_limit INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  shopify_shop_id TEXT,
  shop_domain TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  timezone TEXT NOT NULL DEFAULT 'UTC',
  currency_code CHAR(3) NOT NULL DEFAULT 'USD',
  country_code CHAR(2),
  niche TEXT,
  revenue_band TEXT,
  aov_band TEXT,
  benchmark_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  installed_at TIMESTAMPTZ,
  uninstalled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE store_user_permissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role user_role NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, user_id)
);

CREATE TABLE integration_accounts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
  connector connector_type NOT NULL,
  external_account_id TEXT,
  display_name TEXT,
  encrypted_access_token BYTEA,
  encrypted_refresh_token BYTEA,
  token_expires_at TIMESTAMPTZ,
  scopes TEXT[] NOT NULL DEFAULT '{}',
  status sync_status NOT NULL DEFAULT 'pending',
  last_sync_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, connector, external_account_id)
);

CREATE TABLE sync_runs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  integration_account_id UUID NOT NULL REFERENCES integration_accounts(id) ON DELETE CASCADE,
  resource_type TEXT NOT NULL,
  status sync_status NOT NULL DEFAULT 'pending',
  cursor_value TEXT,
  started_at TIMESTAMPTZ,
  finished_at TIMESTAMPTZ,
  records_read INTEGER NOT NULL DEFAULT 0,
  records_written INTEGER NOT NULL DEFAULT 0,
  error_message TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  provider_product_id TEXT NOT NULL,
  title TEXT NOT NULL,
  handle TEXT,
  vendor TEXT,
  product_type TEXT,
  status TEXT,
  tags TEXT[] NOT NULL DEFAULT '{}',
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, provider_product_id)
);

CREATE TABLE product_variants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  provider_variant_id TEXT NOT NULL,
  sku TEXT,
  title TEXT,
  price_minor BIGINT NOT NULL DEFAULT 0,
  compare_at_price_minor BIGINT,
  cost_minor BIGINT,
  inventory_policy TEXT,
  barcode TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, provider_variant_id)
);

CREATE TABLE inventory_levels (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
  location_id TEXT,
  available_quantity INTEGER NOT NULL DEFAULT 0,
  committed_quantity INTEGER NOT NULL DEFAULT 0,
  incoming_quantity INTEGER NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, variant_id, location_id)
);

CREATE TABLE customers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  provider_customer_id TEXT NOT NULL,
  email_hash TEXT,
  phone_hash TEXT,
  first_name_encrypted BYTEA,
  last_name_encrypted BYTEA,
  country_code CHAR(2),
  orders_count INTEGER NOT NULL DEFAULT 0,
  total_spent_minor BIGINT NOT NULL DEFAULT 0,
  first_order_at TIMESTAMPTZ,
  last_order_at TIMESTAMPTZ,
  accepts_marketing BOOLEAN,
  tags TEXT[] NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, provider_customer_id)
);

CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  customer_id UUID REFERENCES customers(id),
  provider_order_id TEXT NOT NULL,
  order_number TEXT,
  financial_status TEXT,
  fulfillment_status TEXT,
  source_name TEXT,
  currency_code CHAR(3) NOT NULL,
  subtotal_minor BIGINT NOT NULL DEFAULT 0,
  discount_minor BIGINT NOT NULL DEFAULT 0,
  tax_minor BIGINT NOT NULL DEFAULT 0,
  shipping_minor BIGINT NOT NULL DEFAULT 0,
  total_minor BIGINT NOT NULL DEFAULT 0,
  refund_minor BIGINT NOT NULL DEFAULT 0,
  net_revenue_minor BIGINT NOT NULL DEFAULT 0,
  gross_profit_minor BIGINT,
  processed_at TIMESTAMPTZ NOT NULL,
  cancelled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, provider_order_id)
);

CREATE TABLE order_line_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id),
  variant_id UUID REFERENCES product_variants(id),
  provider_line_item_id TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price_minor BIGINT NOT NULL,
  discount_minor BIGINT NOT NULL DEFAULT 0,
  total_minor BIGINT NOT NULL,
  cost_minor BIGINT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, provider_line_item_id)
);

CREATE TABLE refunds (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  provider_refund_id TEXT NOT NULL,
  amount_minor BIGINT NOT NULL,
  reason TEXT,
  processed_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, provider_refund_id)
);

CREATE TABLE discounts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  provider_discount_id TEXT,
  code TEXT,
  title TEXT,
  discount_type TEXT,
  value NUMERIC(18, 4),
  starts_at TIMESTAMPTZ,
  ends_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE ad_accounts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  connector connector_type NOT NULL,
  provider_account_id TEXT NOT NULL,
  name TEXT NOT NULL,
  currency_code CHAR(3),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, connector, provider_account_id)
);

CREATE TABLE ad_campaigns (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  ad_account_id UUID NOT NULL REFERENCES ad_accounts(id) ON DELETE CASCADE,
  provider_campaign_id TEXT NOT NULL,
  name TEXT NOT NULL,
  channel TEXT NOT NULL,
  campaign_type TEXT,
  status TEXT,
  objective TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, provider_campaign_id, channel)
);

CREATE TABLE recommendations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  category TEXT NOT NULL,
  title TEXT NOT NULL,
  summary TEXT NOT NULL,
  reasoning JSONB NOT NULL DEFAULT '{}'::jsonb,
  expected_revenue_impact_minor BIGINT,
  confidence_score NUMERIC(5, 4) NOT NULL CHECK (confidence_score >= 0 AND confidence_score <= 1),
  effort_score INTEGER CHECK (effort_score BETWEEN 1 AND 5),
  risk_score INTEGER CHECK (risk_score BETWEEN 1 AND 5),
  status recommendation_status NOT NULL DEFAULT 'new',
  expires_at TIMESTAMPTZ,
  created_by TEXT NOT NULL DEFAULT 'ai',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE ai_insights (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  type insight_type NOT NULL,
  title TEXT NOT NULL,
  narrative TEXT NOT NULL,
  evidence JSONB NOT NULL DEFAULT '[]'::jsonb,
  source_metric_refs JSONB NOT NULL DEFAULT '[]'::jsonb,
  confidence_score NUMERIC(5, 4) NOT NULL CHECK (confidence_score >= 0 AND confidence_score <= 1),
  generated_for_date DATE,
  generated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE forecasts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  forecast_type TEXT NOT NULL,
  entity_type TEXT,
  entity_id UUID,
  horizon_days INTEGER NOT NULL,
  forecast_start DATE NOT NULL,
  forecast_end DATE NOT NULL,
  predicted_value NUMERIC(18, 4) NOT NULL,
  lower_bound NUMERIC(18, 4),
  upper_bound NUMERIC(18, 4),
  model_name TEXT NOT NULL,
  model_version TEXT NOT NULL,
  features JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE chat_threads (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  title TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  thread_id UUID NOT NULL REFERENCES chat_threads(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant', 'tool', 'system')),
  content TEXT NOT NULL,
  data_refs JSONB NOT NULL DEFAULT '[]'::jsonb,
  token_usage JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE benchmark_cohorts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cohort_key TEXT NOT NULL UNIQUE,
  niche TEXT,
  revenue_band TEXT,
  geography TEXT,
  aov_band TEXT,
  lifecycle_stage TEXT,
  minimum_store_count INTEGER NOT NULL DEFAULT 20,
  current_store_count INTEGER NOT NULL DEFAULT 0,
  is_publishable BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE benchmark_memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  cohort_id UUID NOT NULL REFERENCES benchmark_cohorts(id) ON DELETE CASCADE,
  valid_from DATE NOT NULL,
  valid_to DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (store_id, cohort_id, valid_from)
);

CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
  store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id),
  action TEXT NOT NULL,
  target_type TEXT,
  target_id TEXT,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_stores_org ON stores (organization_id);
CREATE INDEX idx_orders_store_processed ON orders (store_id, processed_at DESC);
CREATE INDEX idx_line_items_store_variant ON order_line_items (store_id, variant_id);
CREATE INDEX idx_inventory_store_variant ON inventory_levels (store_id, variant_id);
CREATE INDEX idx_recommendations_store_status ON recommendations (store_id, status, created_at DESC);
CREATE INDEX idx_ai_insights_store_type_date ON ai_insights (store_id, type, generated_for_date DESC);
CREATE INDEX idx_forecasts_store_type_horizon ON forecasts (store_id, forecast_type, horizon_days, forecast_start DESC);
CREATE INDEX idx_chat_threads_store_user ON chat_threads (store_id, user_id, updated_at DESC);
CREATE INDEX idx_audit_logs_org_created ON audit_logs (organization_id, created_at DESC);
