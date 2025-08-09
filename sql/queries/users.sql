-- name: CreateUser :one
INSERT INTO istanahp.users (name, description)
VALUES ($1, $2)
ON CONFLICT (name) DO NOTHING
RETURNING *;

-- name: GetUserByUsername :one
SELECT * FROM istanahp.users
WHERE username = $1;
