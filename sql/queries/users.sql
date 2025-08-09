-- name: CreateUser :one
INSERT INTO istanahp.users (role_id, name, username, password_hash, email, phone)
VALUES ($1, $2, $3, $4, $5, $6)
ON CONFLICT (username) DO NOTHING
RETURNING *;

-- name: GetUserByUsername :one
SELECT * FROM istanahp.users
WHERE username = $1;

-- name: GetUserByID :one
SELECT * FROM istanahp.users
WHERE id = $1 AND deleted_at IS NULL;

-- name: GetRoleByID :one
SELECT * FROM istanahp.roles
WHERE id = $1 AND deleted_at IS NULL;

-- name: CountCustomers :one
SELECT COUNT(*) FROM istanahp.customers
WHERE deleted_at IS NULL;
