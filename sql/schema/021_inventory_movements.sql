-- +goose up
CREATE TABLE IF NOT EXISTS inventory_movements (
    id BIGSERIAL PRIMARY KEY,
    product_id UUID NOT NULL,               -- The product whose stock changed
    movement_type_id UUID NOT NULL,         -- Type of movement (e.g., sale, purchase, adjustment)
    quantity_change INTEGER NOT NULL,       -- The change in quantity (positive for in, negative for out)
    current_stock_snapshot INTEGER,         -- Stock level *after* this movement (for easier auditing)
    source_transaction_id UUID,             -- Generic FK, or specific FKs below
    -- Specific foreign keys to source transactions (only one should be non-NULL)
    sale_item_id UUID,
    purchase_item_id UUID,
    sale_return_id UUID,
    user_id UUID,                           -- User who initiated the movement/transaction
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Seldom updated, but for consistency
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (movement_type_id) REFERENCES inventory_movement_types(id),
    FOREIGN KEY (sale_item_id) REFERENCES sale_items(id),
    FOREIGN KEY (purchase_item_id) REFERENCES purchase_items(id),
    FOREIGN KEY (sale_return_id) REFERENCES sale_returns(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
COMMENT ON TABLE inventory_movements IS 'Logs all changes to inventory levels for auditing and historical analysis.';
CREATE INDEX idx_inventory_movements_product_id ON inventory_movements (product_id);
CREATE INDEX idx_inventory_movements_created_at ON inventory_movements (created_at);
CREATE INDEX idx_inventory_movements_movement_type_id ON inventory_movements (movement_type_id);

-- +goose down
DROP INDEX IF EXISTS idx_inventory_movements_movement_type_id;
DROP INDEX IF EXISTS idx_inventory_movements_created_at;
DROP INDEX IF EXISTS idx_inventory_movements_product_id;
DROP TABLE IF EXISTS inventory_movements;
