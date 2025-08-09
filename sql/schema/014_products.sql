-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.products (
    id BIGSERIAL PRIMARY KEY,
    category_id BIGSERIAL, -- Foreign Key to product_categories
    tax_rate_id BIGSERIAL,  -- Foreign Key to tax_rates
    name VARCHAR(255) NOT NULL,
    sku VARCHAR(100) UNIQUE NOT NULL, -- Stock Keeping Unit
    barcode VARCHAR(255) UNIQUE, -- If different from SKU, e.g., EAN/UPC
    description TEXT,
    cost_price NUMERIC(19,2) NOT NULL, -- The base cost of the product
    retail_price NUMERIC(19,2) NOT NULL, -- The default selling price
    -- sale_price_non or alternate_retail_price might be added back if tiered pricing is needed
    customer_price NUMERIC(19,2), -- Price for specific customers or groups
    reorder_level INTEGER NOT NULL DEFAULT 0, -- Min stock before reordering
    is_active BOOLEAN NOT NULL DEFAULT TRUE, -- For soft deleting products
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    FOREIGN KEY (category_id) REFERENCES istanahp.product_categories(id),
    FOREIGN KEY (tax_rate_id) REFERENCES istanahp.tax_rates(id)
);
COMMENT ON TABLE istanahp.products IS 'Main product catalog with details.';
CREATE INDEX idx_products_sku ON istanahp.products (sku);
CREATE INDEX idx_products_barcode ON istanahp.products (barcode);
CREATE INDEX idx_products_category_id ON istanahp.products (category_id);

-- +goose down
DROP INDEX IF EXISTS idx_products_category_id;
DROP INDEX IF EXISTS idx_products_barcode;
DROP INDEX IF EXISTS idx_products_sku;
DROP TABLE IF EXISTS istanahp.products;
