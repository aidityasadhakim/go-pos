-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.transaction_payments (
    id BIGSERIAL PRIMARY KEY,
    transaction_type VARCHAR(50) NOT NULL, -- 'sale_payment' or 'purchase_payment'
    transaction_id BIGSERIAL NOT NULL,          -- Refers to sales.id or purchases.id
    payment_method_id BIGSERIAL NOT NULL,       -- Foreign Key to payment_methods
    user_id UUID NOT NULL,                 -- User who recorded the payment
    amount NUMERIC(19,2) NOT NULL,
    payment_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    FOREIGN KEY (payment_method_id) REFERENCES istanahp.payment_methods(id),
    FOREIGN KEY (user_id) REFERENCES istanahp.users(id)
    -- Polymorphic foreign key here requires application-level enforcement or a more complex schema
);
COMMENT ON TABLE istanahp.transaction_payments IS 'Records all payments made for sales (claims) or purchases (debts).';
CREATE INDEX idx_transaction_payments_transaction_id ON istanahp.transaction_payments (transaction_id);
CREATE INDEX idx_transaction_payments_payment_date ON istanahp.transaction_payments (payment_date);

-- +goose down
DROP INDEX IF EXISTS idx_transaction_payments_payment_date;
DROP INDEX IF EXISTS idx_transaction_payments_transaction_id;
DROP TABLE IF EXISTS istanahp.transaction_payments;
