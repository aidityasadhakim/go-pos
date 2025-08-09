-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.purchase_items (
    id BIGSERIAL PRIMARY KEY,
    purchase_id BIGSERIAL NOT NULL,   -- Foreign Key to purchases
    product_id BIGSERIAL NOT NULL,    -- Foreign Key to products quantity INTEGER NOT NULL, unit_cost NUMERIC(19,2) NOT NULL, -- Cost per unit at time of purchase
    line_item_total NUMERIC(19,2) NOT NULL, -- quantity * unit_cost
    FOREIGN KEY (purchase_id) REFERENCES istanahp.purchases(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES istanahp.products(id)
);
COMMENT ON TABLE istanahp.purchase_items IS 'Details of products in a purchase order.';
CREATE INDEX idx_purchase_items_purchase_id ON istanahp.purchase_items (purchase_id);
CREATE INDEX idx_purchase_items_product_id ON istanahp.purchase_items (product_id);

-- +goose down
DROP INDEX IF EXISTS idx_purchase_items_product_id;
DROP INDEX IF EXISTS idx_purchase_items_purchase_id;
DROP TABLE IF EXISTS istanahp.purchase_items;
