-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.sale_types (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'Retail Sale', 'Service', 'Online Order'
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);
COMMENT ON TABLE istanahp.sale_types IS 'Defines the general type of a sale (e.g., retail, service).';

-- +goose down
DROP TABLE IF EXISTS istanahp.sale_types;
