-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.customers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NULL, -- Optional for basic customers
    phone VARCHAR(20) UNIQUE NULL,  -- Optional for basic customers
    address TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);
COMMENT ON TABLE istanahp.customers IS 'Stores customer information.';
CREATE INDEX idx_customers_email ON istanahp.customers (email);
CREATE INDEX idx_customers_phone ON istanahp.customers (phone);

-- +goose down
DROP INDEX IF EXISTS idx_customers_phone;
DROP INDEX IF EXISTS idx_customers_email;
DROP TABLE IF EXISTS istanahp.customers;
