-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.sale_returns (
    id BIGSERIAL PRIMARY KEY,
    sale_id BIGSERIAL NOT NULL,       -- Original sale
    sale_item_id BIGSERIAL NOT NULL,  -- Original specific sale item being returned
    product_id BIGSERIAL NOT NULL,    -- Product being returned
    user_id UUID NOT NULL,       -- User processing the return
    return_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    quantity INTEGER NOT NULL,
    returned_amount NUMERIC(19,2) NOT NULL, -- Monetary amount credited/returned for this item
    reason TEXT NOT NULL,
    is_restocked BOOLEAN NOT NULL DEFAULT FALSE, -- If the item was put back into inventory
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    FOREIGN KEY (sale_id) REFERENCES istanahp.sales(id),
    FOREIGN KEY (sale_item_id) REFERENCES istanahp.sale_items(id),
    FOREIGN KEY (product_id) REFERENCES istanahp.products(id),
    FOREIGN KEY (user_id) REFERENCES istanahp.users(id)
);
COMMENT ON TABLE istanahp.sale_returns IS 'Records product returns for sales transactions.';
CREATE INDEX idx_sale_returns_sale_id ON istanahp.sale_returns (sale_id);
CREATE INDEX idx_sale_returns_product_id ON istanahp.sale_returns (product_id);

-- +goose down
DROP INDEX IF EXISTS idx_sale_returns_product_id;
DROP INDEX IF EXISTS idx_sale_returns_sale_id;
DROP TABLE IF EXISTS istanahp.sale_returns;
