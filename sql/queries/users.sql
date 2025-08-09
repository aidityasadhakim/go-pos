-- name: CreateUser :one
INSERT INTO istanahp.users (role_id, name, username, password_hash, email, phone)
VALUES ($1, $2, $3, $4, $5, $6)
ON CONFLICT (username) DO NOTHING
RETURNING *;

-- name: GetUserByUsername :one
SELECT * FROM istanahp.users
WHERE username = $1;
