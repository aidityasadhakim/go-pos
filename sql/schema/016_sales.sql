-- +goose up
CREATE TABLE IF NOT EXISTS sales (
    id BIGSERIAL PRIMARY KEY,
    sale_status_id UUID NOT NULL, -- Foreign Key to sale_statuses
    sale_type_id UUID NOT NULL,   -- Foreign Key to sale_types (e.g., retail, service)
    payment_method_id UUID NOT NULL, -- Foreign Key to payment_methods
    user_id UUID NOT NULL,        -- Foreign Key to users (cashier/user who made the sale)
    customer_id UUID,             -- Foreign Key to customers (NULLable for walk-in)
    ecommerce_platform_id UUID,   -- Foreign Key to ecommerce_platforms (NULLable if not ecommerce)
    service_category_id UUID,     -- Foreign Key to service_categories (NULLable if not service sale)

    invoice_number VARCHAR(100) UNIQUE NOT NULL DEFAULT '', -- Unique sales code/invoice number
    transaction_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    customer_display_name VARCHAR(255), -- For walk-in customers or custom names
    total_amount DECIMAL(10, 2) NOT NULL, -- Gross total
    total_discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- Total discount applied to the sale
    total_tax_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- Total tax collected

    amount_tendered DECIMAL(10, 2), -- Amount customer paid (cash/card)
    change_given DECIMAL(10, 2),    -- Change due to customer
    payment_at TIMESTAMPTZ,         -- When payment was actually completed
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    FOREIGN KEY (sale_status_id) REFERENCES sale_statuses(id),
    FOREIGN KEY (sale_type_id) REFERENCES sale_types(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (ecommerce_platform_id) REFERENCES ecommerce_platforms(id),
    FOREIGN KEY (service_category_id) REFERENCES service_categories(id)
);
COMMENT ON TABLE sales IS 'Records individual sales transactions.';
CREATE INDEX idx_sales_invoice_number ON sales (invoice_number);
CREATE INDEX idx_sales_transaction_date ON sales (transaction_date);
CREATE INDEX idx_sales_user_id ON sales (user_id);
CREATE INDEX idx_sales_customer_id ON sales (customer_id);

-- +goose down
DROP INDEX IF EXISTS idx_sales_customer_id;
DROP INDEX IF EXISTS idx_sales_user_id;
DROP INDEX IF EXISTS idx_sales_transaction_date;
DROP INDEX IF EXISTS idx_sales_invoice_number;
DROP TABLE IF EXISTS sales;
