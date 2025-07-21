-- +goose up
CREATE TABLE IF NOT EXISTS sale_items (
    id BIGSERIAL PRIMARY KEY,
    sale_id UUID NOT NULL,      -- Foreign Key to sales
    product_id UUID NOT NULL,   -- Foreign Key to products
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL, -- Price at the time of sale
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- Discount on this specific item
    line_item_total DECIMAL(10, 2) NOT NULL, -- quantity * (unit_price - discount_amount)
    FOREIGN KEY (sale_id) REFERENCES sales(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);
COMMENT ON TABLE sale_items IS 'Details of products sold in a sale transaction.';
CREATE INDEX idx_sale_items_sale_id ON sale_items (sale_id);
CREATE INDEX idx_sale_items_product_id ON sale_items (product_id);

-- +goose down
DROP INDEX IF EXISTS idx_sale_items_product_id;
DROP INDEX IF EXISTS idx_sale_items_sale_id;
DROP TABLE IF EXISTS sale_items;
