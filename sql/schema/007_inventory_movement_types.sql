-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.inventory_movement_types (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'Sale', 'Purchase', 'Return (In)', 'Return (Out)', 'Adjustment (In)', 'Adjustment (Out)', 'Damage', 'Loss'
    description TEXT,
    is_inbound BOOLEAN NOT NULL, -- True for incoming stock, False for outgoing
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);
COMMENT ON TABLE istanahp.inventory_movement_types IS 'Defines types of inventory changes (in/out).';

-- +goose down
DROP TABLE IF EXISTS istanahp.inventory_movement_types;
