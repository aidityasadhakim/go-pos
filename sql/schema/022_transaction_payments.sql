-- +goose up
CREATE TABLE IF NOT EXISTS transaction_payments (
    id BIGSERIAL PRIMARY KEY,
    transaction_type VARCHAR(50) NOT NULL, -- 'sale_payment' or 'purchase_payment'
    transaction_id UUID NOT NULL,          -- Refers to sales.id or purchases.id
    payment_method_id UUID NOT NULL,       -- Foreign Key to payment_methods
    user_id UUID NOT NULL,                 -- User who recorded the payment
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
    -- Polymorphic foreign key here requires application-level enforcement or a more complex schema
);
COMMENT ON TABLE transaction_payments IS 'Records all payments made for sales (claims) or purchases (debts).';
CREATE INDEX idx_transaction_payments_transaction_id ON transaction_payments (transaction_id);
CREATE INDEX idx_transaction_payments_payment_date ON transaction_payments (payment_date);

-- +goose down
DROP INDEX IF EXISTS idx_transaction_payments_payment_date;
DROP INDEX IF EXISTS idx_transaction_payments_transaction_id;
DROP TABLE IF EXISTS transaction_payments;
