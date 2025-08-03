-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.inventory_movements (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGSERIAL NOT NULL,               -- The product whose stock changed
    movement_type_id BIGSERIAL NOT NULL,         -- Type of movement (e.g., sale, purchase, adjustment)
    quantity_change INTEGER NOT NULL,       -- The change in quantity (positive for in, negative for out)
    current_stock_snapshot INTEGER,         -- Stock level *after* this movement (for easier auditing)
    source_transaction_id BIGSERIAL,             -- Generic FK, or specific FKs below
    -- Specific foreign keys to source transactions (only one should be non-NULL)
    sale_item_id BIGSERIAL,
    purchase_item_id BIGSERIAL,
    sale_return_id BIGSERIAL,
    user_id UUID,                           -- User who initiated the movement/transaction
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Seldom updated, but for consistency
    FOREIGN KEY (product_id) REFERENCES istanahp.products(id),
    FOREIGN KEY (movement_type_id) REFERENCES istanahp.inventory_movement_types(id),
    FOREIGN KEY (sale_item_id) REFERENCES istanahp.sale_items(id),
    FOREIGN KEY (purchase_item_id) REFERENCES istanahp.purchase_items(id),
    FOREIGN KEY (sale_return_id) REFERENCES istanahp.sale_returns(id),
    FOREIGN KEY (user_id) REFERENCES istanahp.users(id)
);
COMMENT ON TABLE istanahp.inventory_movements IS 'Logs all changes to inventory levels for auditing and historical analysis.';
CREATE INDEX idx_inventory_movements_product_id ON istanahp.inventory_movements (product_id);
CREATE INDEX idx_inventory_movements_created_at ON istanahp.inventory_movements (created_at);
CREATE INDEX idx_inventory_movements_movement_type_id ON istanahp.inventory_movements (movement_type_id);

-- +goose down
DROP INDEX IF EXISTS idx_inventory_movements_movement_type_id;
DROP INDEX IF EXISTS idx_inventory_movements_created_at;
DROP INDEX IF EXISTS idx_inventory_movements_product_id;
DROP TABLE IF EXISTS istanahp.inventory_movements;
