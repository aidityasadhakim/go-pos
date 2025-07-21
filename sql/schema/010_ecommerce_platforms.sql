-- +goose up
CREATE TABLE IF NOT EXISTS ecommerce_platforms (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'Shopee', 'Tokopedia', 'Shopify'
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);
COMMENT ON TABLE ecommerce_platforms IS 'Defines e-commerce platforms sales might originate from.';

-- +goose down
DROP TABLE IF EXISTS ecommerce_platforms;
