-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.suppliers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255) UNIQUE,
    address TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);
COMMENT ON TABLE istanahp.suppliers IS 'Stores supplier information.';
CREATE INDEX idx_suppliers_name ON istanahp.suppliers (name);

-- +goose down
DROP INDEX IF EXISTS idx_suppliers_name;
DROP TABLE IF EXISTS istanahp.suppliers;
