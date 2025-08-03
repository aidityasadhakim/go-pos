-- +goose up
CREATE TABLE IF NOT EXISTS istanahp.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id BIGSERIAL NOT NULL, -- Foreign Key to roles table
    name VARCHAR(255) NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Store bcrypt hashes
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_login_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    FOREIGN KEY (role_id) REFERENCES istanahp.roles(id)
);
COMMENT ON TABLE istanahp.users IS 'Manages staff accounts with role-based access.';
CREATE INDEX idx_users_username ON istanahp.users (username);
CREATE INDEX idx_users_role_id ON istanahp.users (role_id);

-- +goose down
DROP INDEX IF EXISTS idx_users_role_id;
DROP INDEX IF EXISTS idx_users_username;
DROP TABLE IF EXISTS istanahp.users;
