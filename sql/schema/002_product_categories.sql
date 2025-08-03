-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.product_categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'Accessories', 'Part', 'Unit', 'Tools'
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);
COMMENT ON TABLE istanahp.product_categories IS 'Defines categories for products/items.';

-- +goose down
DROP TABLE IF EXISTS istanahp.product_categories;