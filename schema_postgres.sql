-- ========================================================
-- FairCircle (ফেয়ার-সার্কেল) — PostgreSQL Database Schema
-- Optimized for Neon.tech Serverless PostgreSQL
-- ========================================================

-- Enable pgcrypto for UUID generation if not already active
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. Create Enums
DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('CITIZEN', 'PRODUCER', 'STAKEHOLDER', 'ADMIN');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE ledger_tx_type AS ENUM (
        'WALLET_DEPOSIT', 'ESCROW_LOCK', 'ESCROW_RELEASE', 
        'PREORDER_INVEST', 'QARD_HASAN_LEND', 'QARD_HASAN_REPAY', 'CIRCULATION_DUTY'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE product_category AS ENUM (
        'FOOD_AGRO', 'HANDLOOM_APPAREL', 'WOOD_CRAFT', 'HEALTH_CLINIC', 'HOUSEHOLD'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE escrow_status AS ENUM (
        'FUNDS_LOCKED', 'DISPATCHED_PROOF_UPLOADED', 'DELIVERED_INSPECTING', 
        'SATISFIED_RELEASED', 'DISPUTED_RESOLVING', 'REFUNDED'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE campaign_status AS ENUM (
        'FUNDING_ACTIVE', 'TARGET_REACHED', 'IN_PRODUCTION', 'HARVEST_DELIVERED', 'COMPLETED'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE loan_status AS ENUM (
        'REQUESTED', 'APPROVED_DISBURSED', 'ACTIVE_REPAYING', 'FULLY_REPAID', 'HARDSHIP_EXTENDED'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- 2. Users Table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    avatar_url VARCHAR(255),
    role user_role NOT NULL DEFAULT 'CITIZEN',
    nid_verified BOOLEAN NOT NULL DEFAULT FALSE,
    reputation_score NUMERIC(5,2) NOT NULL DEFAULT 100.00,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. User Wallets (100% Real-Asset Backed, Zero Debt/Overdraft)
CREATE TABLE IF NOT EXISTS wallets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE RESTRICT,
    available_balance NUMERIC(14,2) NOT NULL DEFAULT 0.00 CHECK (available_balance >= 0.00),
    locked_escrow_balance NUMERIC(14,2) NOT NULL DEFAULT 0.00 CHECK (locked_escrow_balance >= 0.00),
    currency VARCHAR(10) NOT NULL DEFAULT 'BDT',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Double-Entry Immutable Financial Ledger
-- Prohibits any compound interest or unbacked money creation
CREATE TABLE IF NOT EXISTS ledger_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_wallet_id UUID REFERENCES wallets(id),
    to_wallet_id UUID REFERENCES wallets(id),
    amount NUMERIC(14,2) NOT NULL CHECK (amount > 0.00),
    interest_amount NUMERIC(14,2) NOT NULL DEFAULT 0.00 CHECK (interest_amount = 0.00), -- Strictly 0.00 enforced
    transaction_type ledger_tx_type NOT NULL,
    reference_id UUID,
    notes VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. Marketplace Products (B2C / Producer Storefront)
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    producer_id UUID NOT NULL REFERENCES users(id),
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category product_category NOT NULL,
    total_price NUMERIC(10,2) NOT NULL CHECK (total_price > 0),
    
    -- Mandatory 100% Transparent Price Breakdown
    raw_material_cost NUMERIC(10,2) NOT NULL CHECK (raw_material_cost >= 0),
    labor_wage_cost NUMERIC(10,2) NOT NULL CHECK (labor_wage_cost >= 0),
    packaging_transport_cost NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    fair_profit_margin NUMERIC(10,2) NOT NULL CHECK (fair_profit_margin >= 0),
    
    stock_quantity INT NOT NULL DEFAULT 1,
    inspection_period_hours INT NOT NULL DEFAULT 48,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Autonomous 48-Hour Escrow Orders
CREATE TABLE IF NOT EXISTS escrow_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    buyer_id UUID NOT NULL REFERENCES users(id),
    producer_id UUID NOT NULL REFERENCES users(id),
    product_id UUID NOT NULL REFERENCES products(id),
    order_amount NUMERIC(12,2) NOT NULL,
    status escrow_status NOT NULL DEFAULT 'FUNDS_LOCKED',
    seller_dispatch_video_url VARCHAR(255),
    inspection_deadline TIMESTAMPTZ NULL,
    buyer_feedback_satisfaction BOOLEAN,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 7. Forward Production Campaigns (C2B / Salam Model)
CREATE TABLE IF NOT EXISTS preorder_campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    producer_id UUID NOT NULL REFERENCES users(id),
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    target_amount NUMERIC(14,2) NOT NULL CHECK (target_amount > 0),
    current_funded_amount NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    share_price NUMERIC(10,2) NOT NULL CHECK (share_price > 0),
    total_shares INT NOT NULL,
    sold_shares INT NOT NULL DEFAULT 0,
    unit_return_yield VARCHAR(100) NOT NULL,
    estimated_retail_value NUMERIC(10,2) NOT NULL,
    harvest_delivery_date DATE NOT NULL,
    status campaign_status NOT NULL DEFAULT 'FUNDING_ACTIVE',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 8. Pre-Order Buyer Shares
CREATE TABLE IF NOT EXISTS preorder_shares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL REFERENCES preorder_campaigns(id),
    user_id UUID NOT NULL REFERENCES users(id),
    shares_count INT NOT NULL DEFAULT 1,
    total_amount_paid NUMERIC(12,2) NOT NULL,
    is_yield_delivered BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 9. 0% Interest Benevolent Loan Pools (Qard Hasan)
CREATE TABLE IF NOT EXISTS qard_hasan_pools (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL,
    area_district VARCHAR(100) NOT NULL,
    total_reserve_pool NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    currently_lent_out NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    interest_rate NUMERIC(4,2) NOT NULL DEFAULT 0.00 CHECK (interest_rate = 0.00),
    late_penalty_rate NUMERIC(4,2) NOT NULL DEFAULT 0.00 CHECK (late_penalty_rate = 0.00),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 10. Benevolent Emergency Loans (0% Interest)
CREATE TABLE IF NOT EXISTS qard_hasan_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pool_id UUID NOT NULL REFERENCES qard_hasan_pools(id),
    borrower_id UUID NOT NULL REFERENCES users(id),
    principal_amount NUMERIC(10,2) NOT NULL CHECK (principal_amount > 0),
    repaid_amount NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    installment_months INT NOT NULL DEFAULT 6,
    purpose TEXT NOT NULL,
    status loan_status NOT NULL DEFAULT 'REQUESTED',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 11. Community Tool & Machinery Library (C2C Sharing)
CREATE TABLE IF NOT EXISTS tool_shares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id),
    title VARCHAR(150) NOT NULL,
    category VARCHAR(80) NOT NULL,
    security_deposit NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    fuel_maintenance_fee NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 12. User Self-Regulation Financial Profiles
CREATE TABLE IF NOT EXISTS user_financial_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id),
    monthly_net_income NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    shield_percentage INT NOT NULL DEFAULT 40,
    active_usury_debt NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    idle_stagnant_savings NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    mutual_aid_given_annual NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    conscience_score INT NOT NULL DEFAULT 100,
    last_zakat_calculated_at TIMESTAMPTZ NULL,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ========================================================
-- Seed Initial Data for Bangladesh Real Economy
-- ========================================================
INSERT INTO users (id, phone_number, full_name, role, nid_verified, reputation_score)
VALUES 
  ('a0000000-0000-0000-0000-000000000001', '01711000001', 'পাবনা সরিষা কৃষক সমবায়', 'PRODUCER', TRUE, 99.50),
  ('a0000000-0000-0000-0000-000000000002', '01711000002', 'টাঙ্গাইল খাদি তাঁত সমবায়', 'PRODUCER', TRUE, 98.70),
  ('a0000000-0000-0000-0000-000000000003', '01811000001', 'সাদিকুর রহমান', 'CITIZEN', TRUE, 100.00)
ON CONFLICT (phone_number) DO NOTHING;

INSERT INTO wallets (user_id, available_balance, locked_escrow_balance, currency)
VALUES
  ('a0000000-0000-0000-0000-000000000001', 25000.00, 0.00, 'BDT'),
  ('a0000000-0000-0000-0000-000000000002', 15000.00, 0.00, 'BDT'),
  ('a0000000-0000-0000-0000-000000000003', 50000.00, 0.00, 'BDT')
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO products (producer_id, title, description, category, total_price, raw_material_cost, labor_wage_cost, packaging_transport_cost, fair_profit_margin, stock_quantity)
VALUES
  ('a0000000-0000-0000-0000-000000000001', 'কাঠের ঘানির খাঁটি সরিষার তেল (৫ লিটার)', 'দেশি মাঘী সরিষা থেকে কাঠের ঘানিতে ভাঙানো ১০০% খাঁটি তেল।', 'FOOD_AGRO', 2400.00, 1850.00, 180.00, 0.00, 370.00, 50),
  ('a0000000-0000-0000-0000-000000000002', 'হাতে কাটা দেশি খাদি সুতির পাঞ্জাবী', 'প্রাকৃতিক খাদি তুলা ও ভেষজ রঙে তৈরি শতভাগ আরামদায়ক পোশাক।', 'HANDLOOM_APPAREL', 1500.00, 650.00, 700.00, 0.00, 150.00, 30)
ON CONFLICT DO NOTHING;

INSERT INTO qard_hasan_pools (name, area_district, total_reserve_pool, currently_lent_out)
VALUES
  ('ঢাকা মিরপুর সুদমুক্ত পাড়া তহবিল', 'Dhaka-Mirpur', 250000.00, 140000.00)
ON CONFLICT DO NOTHING;
