-- +goose up
CREATE TABLE IF NOT EXISTS purchase_statuses (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'Pending Order', 'Received', 'Cancelled', 'Returned'
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);
COMMENT ON TABLE purchase_statuses IS 'Defines the status of a purchase order.';

-- +goose down
DROP TABLE IF EXISTS purchase_statuses;
