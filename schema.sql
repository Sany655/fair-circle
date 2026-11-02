-- ========================================================
-- FairCircle (ফেয়ার-সার্কেল) — Production Database Schema
-- Target Engine: MySQL 8.0+ / MariaDB (InnoDB)
-- ========================================================

CREATE DATABASE IF NOT EXISTS faircircle_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE faircircle_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    avatar_url VARCHAR(255),
    role ENUM('CITIZEN', 'PRODUCER', 'STAKEHOLDER', 'ADMIN') NOT NULL DEFAULT 'CITIZEN',
    nid_verified BOOLEAN NOT NULL DEFAULT FALSE,
    reputation_score DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_phone (phone_number),
    INDEX idx_user_role (role)
) ENGINE=InnoDB;

-- 2. User Wallets (100% Real-Asset Backed, Zero Debt/Overdraft)
CREATE TABLE IF NOT EXISTS wallets (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL UNIQUE,
    available_balance DECIMAL(14,2) NOT NULL DEFAULT 0.00 CHECK (available_balance >= 0.00),
    locked_escrow_balance DECIMAL(14,2) NOT NULL DEFAULT 0.00 CHECK (locked_escrow_balance >= 0.00),
    currency VARCHAR(10) NOT NULL DEFAULT 'BDT',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 3. Double-Entry Immutable Financial Ledger
-- Prohibits any compound interest or fictitious money creation
CREATE TABLE IF NOT EXISTS ledger_transactions (
    id VARCHAR(36) PRIMARY KEY,
    from_wallet_id VARCHAR(36),
    to_wallet_id VARCHAR(36),
    amount DECIMAL(14,2) NOT NULL CHECK (amount > 0.00),
    interest_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00 CHECK (interest_amount = 0.00),
    transaction_type ENUM('WALLET_DEPOSIT', 'ESCROW_LOCK', 'ESCROW_RELEASE', 'PREORDER_INVEST', 'QARD_HASAN_LEND', 'QARD_HASAN_REPAY', 'CIRCULATION_DUTY') NOT NULL,
    reference_id VARCHAR(36),
    notes VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_wallet_id) REFERENCES wallets(id),
    FOREIGN KEY (to_wallet_id) REFERENCES wallets(id),
    INDEX idx_ledger_type (transaction_type),
    INDEX idx_ledger_ref (reference_id)
) ENGINE=InnoDB;

-- 4. Marketplace Products (B2C / Producer Storefront)
CREATE TABLE IF NOT EXISTS products (
    id VARCHAR(36) PRIMARY KEY,
    producer_id VARCHAR(36) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category ENUM('FOOD_AGRO', 'HANDLOOM_APPAREL', 'WOOD_CRAFT', 'HEALTH_CLINIC', 'HOUSEHOLD') NOT NULL,
    total_price DECIMAL(10,2) NOT NULL CHECK (total_price > 0),
    
    -- Mandatory 100% Transparent Price Breakdown
    raw_material_cost DECIMAL(10,2) NOT NULL CHECK (raw_material_cost >= 0),
    labor_wage_cost DECIMAL(10,2) NOT NULL CHECK (labor_wage_cost >= 0),
    packaging_transport_cost DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    fair_profit_margin DECIMAL(10,2) NOT NULL CHECK (fair_profit_margin >= 0),
    
    stock_quantity INT NOT NULL DEFAULT 1,
    inspection_period_hours INT NOT NULL DEFAULT 48,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producer_id) REFERENCES users(id),
    INDEX idx_prod_cat (category),
    INDEX idx_prod_active (is_active)
) ENGINE=InnoDB;

-- 5. Autonomous 48-Hour Escrow Orders
CREATE TABLE IF NOT EXISTS escrow_orders (
    id VARCHAR(36) PRIMARY KEY,
    buyer_id VARCHAR(36) NOT NULL,
    producer_id VARCHAR(36) NOT NULL,
    product_id VARCHAR(36) NOT NULL,
    order_amount DECIMAL(12,2) NOT NULL,
    status ENUM('FUNDS_LOCKED', 'DISPATCHED_PROOF_UPLOADED', 'DELIVERED_INSPECTING', 'SATISFIED_RELEASED', 'DISPUTED_RESOLVING', 'REFUNDED') NOT NULL DEFAULT 'FUNDS_LOCKED',
    seller_dispatch_video_url VARCHAR(255),
    inspection_deadline TIMESTAMP NULL,
    buyer_feedback_satisfaction BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES users(id),
    FOREIGN KEY (producer_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    INDEX idx_escrow_status (status)
) ENGINE=InnoDB;

-- 6. Forward Production Campaigns (Salam Pre-Orders)
CREATE TABLE IF NOT EXISTS preorder_campaigns (
    id VARCHAR(36) PRIMARY KEY,
    producer_id VARCHAR(36) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    target_amount DECIMAL(14,2) NOT NULL CHECK (target_amount > 0),
    current_funded_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    share_price DECIMAL(10,2) NOT NULL CHECK (share_price > 0),
    total_shares INT NOT NULL,
    sold_shares INT NOT NULL DEFAULT 0,
    unit_return_yield VARCHAR(100) NOT NULL,
    estimated_retail_value DECIMAL(10,2) NOT NULL,
    harvest_delivery_date DATE NOT NULL,
    status ENUM('FUNDING_ACTIVE', 'TARGET_REACHED', 'IN_PRODUCTION', 'HARVEST_DELIVERED', 'COMPLETED') NOT NULL DEFAULT 'FUNDING_ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producer_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- 7. Pre-Order Buyer Shares
CREATE TABLE IF NOT EXISTS preorder_shares (
    id VARCHAR(36) PRIMARY KEY,
    campaign_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    shares_count INT NOT NULL DEFAULT 1,
    total_amount_paid DECIMAL(12,2) NOT NULL,
    is_yield_delivered BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES preorder_campaigns(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- 8. 0% Interest Benevolent Loan Pools (Qard Hasan)
CREATE TABLE IF NOT EXISTS qard_hasan_pools (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    area_district VARCHAR(100) NOT NULL,
    total_reserve_pool DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    currently_lent_out DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    interest_rate DECIMAL(4,2) NOT NULL DEFAULT 0.00 CHECK (interest_rate = 0.00),
    late_penalty_rate DECIMAL(4,2) NOT NULL DEFAULT 0.00 CHECK (late_penalty_rate = 0.00),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 9. Benevolent Emergency Loans (0% Interest)
CREATE TABLE IF NOT EXISTS qard_hasan_loans (
    id VARCHAR(36) PRIMARY KEY,
    pool_id VARCHAR(36) NOT NULL,
    borrower_id VARCHAR(36) NOT NULL,
    principal_amount DECIMAL(10,2) NOT NULL CHECK (principal_amount > 0),
    repaid_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total_due DECIMAL(10,2) GENERATED ALWAYS AS (principal_amount) STORED,
    installment_months INT NOT NULL DEFAULT 6,
    purpose TEXT NOT NULL,
    status ENUM('REQUESTED', 'APPROVED_DISBURSED', 'ACTIVE_REPAYING', 'FULLY_REPAID', 'HARDSHIP_EXTENDED') NOT NULL DEFAULT 'REQUESTED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pool_id) REFERENCES qard_hasan_pools(id),
    FOREIGN KEY (borrower_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- 10. Community Tool & Machinery Library (C2C Sharing)
CREATE TABLE IF NOT EXISTS tool_shares (
    id VARCHAR(36) PRIMARY KEY,
    owner_id VARCHAR(36) NOT NULL,
    title VARCHAR(150) NOT NULL,
    category VARCHAR(80) NOT NULL,
    security_deposit DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    fuel_maintenance_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status ENUM('AVAILABLE', 'IN_USE', 'MAINTENANCE') NOT NULL DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- 11. User Self-Regulation Financial Profiles
CREATE TABLE IF NOT EXISTS user_financial_profiles (
    user_id VARCHAR(36) PRIMARY KEY,
    monthly_net_income DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    shield_percentage INT NOT NULL DEFAULT 40,
    active_usury_debt DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    idle_stagnant_savings DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    mutual_aid_given_annual DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    conscience_score INT NOT NULL DEFAULT 100,
    last_zakat_calculated_at TIMESTAMP NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- ========================================================
-- Seed Initial Demo Data (Bangladeshi Real-Economy Anchors)
-- ========================================================

-- Seed Sample Producer
INSERT IGNORE INTO users (id, phone_number, full_name, role, nid_verified, reputation_score)
VALUES 
  ('usr-producer-01', '01711000001', 'পাবনা সরিষা কৃষক সমবায়', 'PRODUCER', TRUE, 99.50),
  ('usr-producer-02', '01711000002', 'টাঙ্গাইল খাদি তাঁত সমবায়', 'PRODUCER', TRUE, 98.70),
  ('usr-citizen-01',  '01811000001', 'সাদিকুর রহমান', 'CITIZEN', TRUE, 100.00);

-- Seed Producer Wallets
INSERT IGNORE INTO wallets (id, user_id, available_balance, locked_escrow_balance, currency)
VALUES
  ('w-prod-01', 'usr-producer-01', 25000.00, 0.00, 'BDT'),
  ('w-prod-02', 'usr-producer-02', 15000.00, 0.00, 'BDT'),
  ('w-cit-01',  'usr-citizen-01',  50000.00, 0.00, 'BDT');

-- Seed Products with Transparent Cost Sheets
INSERT IGNORE INTO products (id, producer_id, title, description, category, total_price, raw_material_cost, labor_wage_cost, packaging_transport_cost, fair_profit_margin, stock_quantity)
VALUES
  ('prod-01', 'usr-producer-01', 'কাঠের ঘানির খাঁটি সরিষার তেল (৫ লিটার)', 'দেশি মাঘী সরিষা থেকে কাঠের ঘানিতে ভাঙানো ১০০% খাঁটি তেল।', 'FOOD_AGRO', 2400.00, 1850.00, 180.00, 0.00, 370.00, 50),
  ('prod-02', 'usr-producer-02', 'হাতে কাটা দেশি খাদি সুতির পাঞ্জাবী', 'প্রাকৃতিক খাদি তুলা ও ভেষজ রঙে তৈরি শতভাগ আরামদায়ক পোশাক।', 'HANDLOOM_APPAREL', 1500.00, 650.00, 700.00, 0.00, 150.00, 30);

-- Seed 0% Benevolent Emergency Pool
INSERT IGNORE INTO qard_hasan_pools (id, name, area_district, total_reserve_pool, currently_lent_out, interest_rate, late_penalty_rate)
VALUES
  ('pool-01', 'ঢাকা মিরপুর সুদমুক্ত পাড়া তহবিল', 'Dhaka-Mirpur', 250000.00, 140000.00, 0.00, 0.00);
