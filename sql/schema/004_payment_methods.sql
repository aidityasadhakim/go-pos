-- +goose up
CREATE TABLE IF NOT EXISTS payment_methods (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'Cash', 'Credit Card', 'Debit Card', 'Mobile Pay', 'Store Credit'
    description TEXT,
    is_cash_method BOOLEAN NOT NULL DEFAULT FALSE, -- To easily identify cash-like methods
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);
COMMENT ON TABLE payment_methods IS 'Defines types of payment accepted.';