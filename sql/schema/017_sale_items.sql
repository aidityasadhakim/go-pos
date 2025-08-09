-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.sale_items (
    id BIGSERIAL PRIMARY KEY,
    sale_id BIGSERIAL NOT NULL,      -- Foreign Key to sales
    product_id BIGSERIAL NOT NULL,   -- Foreign Key to products
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(19,2) NOT NULL, -- Price at the time of sale
    discount_amount NUMERIC(19,2) NOT NULL DEFAULT 0.00, -- Discount on this specific item
    line_item_total NUMERIC(19,2) NOT NULL, -- quantity * (unit_price - discount_amount)
    FOREIGN KEY (sale_id) REFERENCES istanahp.sales(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES istanahp.products(id)
);
COMMENT ON TABLE istanahp.sale_items IS 'Details of products sold in a sale transaction.';
CREATE INDEX idx_sale_items_sale_id ON istanahp.sale_items (sale_id);
CREATE INDEX idx_sale_items_product_id ON istanahp.sale_items (product_id);

-- +goose down
DROP INDEX IF EXISTS idx_sale_items_product_id;
DROP INDEX IF EXISTS idx_sale_items_sale_id;
DROP TABLE IF EXISTS istanahp.sale_items;
