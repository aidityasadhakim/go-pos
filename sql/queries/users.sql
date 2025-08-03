-- name: CreateUser :one
INSERT INTO istanahp.roles (name, description)
VALUES ($1, $2)
ON CONFLICT (name) DO NOTHING
RETURNING *;

