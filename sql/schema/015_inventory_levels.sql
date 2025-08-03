-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.inventory_levels (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGSERIAL UNIQUE NOT NULL, -- One-to-one with product
    current_stock INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES istanahp.products(id) ON DELETE CASCADE
);
COMMENT ON TABLE istanahp.inventory_levels IS 'Tracks the current stock quantity for each product.';
CREATE INDEX idx_inventory_levels_product_id ON istanahp.inventory_levels (product_id);

-- +goose down
DROP INDEX IF EXISTS idx_inventory_levels_product_id;
DROP TABLE IF EXISTS istanahp.inventory_levels;
