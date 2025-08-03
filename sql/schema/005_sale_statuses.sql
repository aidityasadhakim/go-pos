-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.sale_statuses (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'Pending', 'Completed', 'Cancelled', 'On Hold', 'Refunded'
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);
COMMENT ON TABLE istanahp.sale_statuses IS 'Defines the status of a sales transaction.';

-- +goose down
DROP TABLE IF EXISTS istanahp.sale_statuses;
