-- +goose up
CREATE TABLE IF NOT EXISTS purchases (
    id BIGSERIAL PRIMARY KEY,
    purchase_status_id UUID NOT NULL, -- Foreign Key to purchase_statuses
    supplier_id UUID NOT NULL,        -- Foreign Key to suppliers
    payment_method_id UUID,           -- Foreign Key to payment_methods (can be null for credit purchases)
    user_id UUID NOT NULL,            -- Foreign Key to users (user who made the purchase order)

    order_number VARCHAR(100) UNIQUE NOT NULL DEFAULT '', -- Unique purchase order number
    transaction_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL, -- Total cost of the purchase
    amount_paid DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- Amount paid to supplier
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    FOREIGN KEY (purchase_status_id) REFERENCES purchase_statuses(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
COMMENT ON TABLE purchases IS 'Records purchase orders from suppliers.';
CREATE INDEX idx_purchases_order_number ON purchases (order_number);
CREATE INDEX idx_purchases_transaction_date ON purchases (transaction_date);
CREATE INDEX idx_purchases_supplier_id ON purchases (supplier_id);

-- +goose down
DROP INDEX IF EXISTS idx_purchases_supplier_id;
DROP INDEX IF EXISTS idx_purchases_transaction_date;
DROP INDEX IF EXISTS idx_purchases_order_number;
DROP TABLE IF EXISTS purchases;
