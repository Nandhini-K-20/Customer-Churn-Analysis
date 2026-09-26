create database customers_churn;
use customers_churn;
drop database  customers_churn;
-- 1. CUSTOMERS -----------------------------------------------------------
-- Core customer profile / master table
CREATE TABLE customers (
    customer_id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name          VARCHAR(50),
    last_name           VARCHAR(50),
    email               VARCHAR(100) UNIQUE NOT NULL,
    phone               VARCHAR(50),
    gender              VARCHAR(10),
    date_of_birth       DATE,
    signup_date         DATE NOT NULL,
    country             VARCHAR(50),
    state               VARCHAR(50),
    city                VARCHAR(50),
    acquisition_channel VARCHAR(50),   -- e.g. Organic, Referral, Paid Ad
    is_active           BOOLEAN DEFAULT TRUE,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
-- 2. SUBSCRIPTION_PLANS ---------------------------------------------------
-- Catalog of available plans/products

CREATE TABLE subscription_plans (
    plan_id             INT PRIMARY KEY AUTO_INCREMENT,
    plan_name           VARCHAR(50) NOT NULL,       -- e.g. Basic, Pro, Enterprise
    plan_type           VARCHAR(20),                 -- Monthly / Annual
    monthly_price       DECIMAL(10,2) NOT NULL,
    features            VARCHAR(255),
    is_active           BOOLEAN DEFAULT TRUE
);
 
-- 3. SUBSCRIPTIONS ---------------------------------------------------------
-- Tracks each customer's subscription history (can have multiple over time)
CREATE TABLE subscriptions (
    subscription_id     INT PRIMARY KEY AUTO_INCREMENT,
    customer_id         INT NOT NULL,
    plan_id             INT NOT NULL,
    start_date          DATE NOT NULL,
    end_date            DATE,                        -- NULL if still active
    status              VARCHAR(20) DEFAULT 'Active', -- Active, Cancelled, Expired
    auto_renew          BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id)
);
 
-- 4. BILLING_TRANSACTIONS ---------------------------------------------------
-- Payment / invoice history
CREATE TABLE billing_transactions (
    transaction_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_id         INT NOT NULL,
    subscription_id     INT NOT NULL,
    transaction_date    DATE NOT NULL,
    amount              DECIMAL(10,2) NOT NULL,
    payment_method      VARCHAR(30),                 -- Credit Card, PayPal, UPI...
    payment_status      VARCHAR(20) DEFAULT 'Success',-- Success, Failed, Refunded
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);
 
-- 5. USAGE_ACTIVITY -----------------------------------------------------
-- Product/feature usage logs — key churn predictor (engagement/recency)
CREATE TABLE usage_activity (
    usage_id            INT PRIMARY KEY AUTO_INCREMENT,
    customer_id         INT NOT NULL,
    activity_date        DATE NOT NULL,
    feature_used         VARCHAR(50),
    session_duration_min INT,
    login_count           INT DEFAULT 1,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
 
-- 6. SUPPORT_TICKETS -----------------------------------------------------
-- Customer support interactions
CREATE TABLE support_tickets (
    ticket_id            INT PRIMARY KEY AUTO_INCREMENT,
    customer_id          INT NOT NULL,
    created_date          DATE NOT NULL,
    resolved_date          DATE,
    issue_category        VARCHAR(50),   -- Billing, Technical, Account, Other
    priority               VARCHAR(10),    -- Low, Medium, High, Urgent
    status                 VARCHAR(20) DEFAULT 'Open', -- Open, In Progress, Closed
    satisfaction_rating    INT,             -- 1-5 CSAT score
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
 
-- 7. CUSTOMER_FEEDBACK ---------------------------------------------------
-- Survey / NPS responses
CREATE TABLE customer_feedback (
    feedback_id           INT PRIMARY KEY AUTO_INCREMENT,
    customer_id           INT NOT NULL,
    survey_date            DATE NOT NULL,
    nps_score               INT,              -- 0-10
    csat_score               INT,              -- 1-5
    feedback_text            TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
 
-- 8. MARKETING_CAMPAIGNS --------------------------------------------------
-- Catalog of retention/marketing campaigns
CREATE TABLE marketing_campaigns (
    campaign_id            INT PRIMARY KEY AUTO_INCREMENT,
    campaign_name            VARCHAR(100) NOT NULL,
    campaign_type              VARCHAR(30),   -- Email, SMS, Discount Offer, Push Notification
    start_date                  DATE,
    end_date                    DATE,
    channel                     VARCHAR(30)
);
 
-- 9. CAMPAIGN_INTERACTIONS -------------------------------------------------
-- Tracks how customers respond to retention/marketing campaigns
CREATE TABLE campaign_interactions (
    interaction_id           INT PRIMARY KEY AUTO_INCREMENT,
    campaign_id              INT NOT NULL,
    customer_id               INT NOT NULL,
    sent_date                   DATE,
    opened                       BOOLEAN DEFAULT FALSE,
    clicked                      BOOLEAN DEFAULT FALSE,
    converted                    BOOLEAN DEFAULT FALSE,  -- did it prevent/reduce churn
    FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(campaign_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
 
-- 10. CHURN_EVENTS ----------------------------------------------------------
-- Records actual churn events — the target/label table for analysis
CREATE TABLE churn_events (
    churn_id                 INT PRIMARY KEY AUTO_INCREMENT,
    customer_id                INT NOT NULL,
    subscription_id             INT NOT NULL,
    churn_date                    DATE NOT NULL,
    churn_reason                   VARCHAR(100),   -- Price, Poor Support, Competitor, No Usage...
    voluntary                       BOOLEAN DEFAULT TRUE, -- voluntary vs involuntary (e.g. failed payment)
    tenure_days                     INT,             -- days between signup and churn
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

select count(*) from customers;
select count(*) from subscription_plans;
select count(*) from subscriptions;
select count(*) from billing_transactions;
select count(*) from usage_activity;
select count(*) from support_tickets;
select count(*) from customer_feedback;
select count(*) from marketing_campaigns;
select count(*) from campaign_interactions;
select count(*) from churn_events;



