-- +goose up
CREATE TABLE IF NOT EXISTS tax_rates (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'Sales Tax', 'VAT'
    percentage DECIMAL(5, 2) NOT NULL, -- e.g., 0.0825 for 8.25%
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);
COMMENT ON TABLE tax_rates IS 'Defines different tax rates applicable to products or sales.';

-- +goose down
DROP TABLE IF EXISTS tax_rates;