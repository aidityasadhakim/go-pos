-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.product_cost_lots (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGSERIAL NOT NULL,
    quantity INTEGER NOT NULL, -- Quantity *remaining* in this specific lot
    unit_cost NUMERIC(19, 2) NOT NULL,
    purchase_item_id BIGSERIAL, -- Link to the purchase item that brought this stock in
    received_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at DATE, -- For perishable goods, NULL otherwise
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- When this lot record was created
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- When quantity was last updated
    FOREIGN KEY (product_id) REFERENCES istanahp.products(id),
    FOREIGN KEY (purchase_item_id) REFERENCES istanahp.purchase_items(id)
);
COMMENT ON TABLE istanahp.product_cost_lots IS 'Tracks individual batches of products for cost of goods sold calculations (e.g., FIFO).';
CREATE INDEX idx_product_cost_lots_product_id ON istanahp.product_cost_lots (product_id);
CREATE INDEX idx_product_cost_lots_received_at ON istanahp.product_cost_lots (received_at); -- Important for FIFO
CREATE INDEX idx_product_cost_lots_purchase_item_id ON istanahp.product_cost_lots (purchase_item_id);


-- +goose down
DROP TABLE IF EXISTS istanahp.product_cost_lots;
DROP INDEX IF EXISTS idx_product_cost_lots_product_id;
DROP INDEX IF EXISTS idx_product_cost_lots_received_at;
DROP INDEX IF EXISTS idx_product_cost_lots_purchase_item_id;

