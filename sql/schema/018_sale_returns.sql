-- +goose up
CREATE TABLE IF NOT EXISTS sale_returns (
    id BIGSERIAL PRIMARY KEY,
    sale_id UUID NOT NULL,       -- Original sale
    sale_item_id UUID NOT NULL,  -- Original specific sale item being returned
    product_id UUID NOT NULL,    -- Product being returned
    user_id UUID NOT NULL,       -- User processing the return
    return_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    quantity INTEGER NOT NULL,
    returned_amount DECIMAL(10, 2) NOT NULL, -- Monetary amount credited/returned for this item
    reason TEXT NOT NULL,
    is_restocked BOOLEAN NOT NULL DEFAULT FALSE, -- If the item was put back into inventory
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    FOREIGN KEY (sale_id) REFERENCES sales(id),
    FOREIGN KEY (sale_item_id) REFERENCES sale_items(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
COMMENT ON TABLE sale_returns IS 'Records product returns for sales transactions.';
CREATE INDEX idx_sale_returns_sale_id ON sale_returns (sale_id);
CREATE INDEX idx_sale_returns_product_id ON sale_returns (product_id);

-- +goose down
DROP INDEX IF EXISTS idx_sale_returns_product_id;
DROP INDEX IF EXISTS idx_sale_returns_sale_id;
DROP TABLE IF EXISTS sale_returns;
