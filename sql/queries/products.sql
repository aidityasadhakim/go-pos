-- name: CreateProduct :one
INSERT INTO istanahp.products (
    category_id,
    tax_rate_id,
    name,
    sku,
    description,
    cost_price,
    retail_price,
    customer_price,
    reorder_level,
    is_active
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10
) RETURNING *;

-- name: GetProduct :one
SELECT * FROM istanahp.products
WHERE id = $1 AND deleted_at IS NULL;

-- name: GetProductBySKU :one
SELECT * FROM istanahp.products
WHERE sku = $1 AND deleted_at IS NULL;

-- name: ListProducts :many
SELECT * FROM istanahp.products
WHERE deleted_at IS NULL
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: ListActiveProducts :many
SELECT * FROM istanahp.products
WHERE is_active = TRUE AND deleted_at IS NULL
ORDER BY name ASC;

-- name: ListProductsByCategory :many
SELECT * FROM istanahp.products
WHERE category_id = $1 AND deleted_at IS NULL
ORDER BY name ASC;

-- name: SearchProducts :many
SELECT * FROM istanahp.products
WHERE (
    name ILIKE '%' || $1 || '%' OR
    sku ILIKE '%' || $1 || '%' OR
    description ILIKE '%' || $1 || '%'
) AND deleted_at IS NULL
ORDER BY name ASC
LIMIT $2 OFFSET $3;

-- name: UpdateProduct :one
UPDATE istanahp.products
SET 
    category_id = $2,
    tax_rate_id = $3,
    name = $4,
    sku = $5,
    description = $6,
    cost_price = $7,
    retail_price = $8,
    customer_price = $9,
    reorder_level = $10,
    is_active = $11,
    updated_at = CURRENT_TIMESTAMP
WHERE id = $1 AND deleted_at IS NULL
RETURNING *;

-- name: UpdateProductPrice :one
UPDATE istanahp.products
SET 
    cost_price = $2,
    retail_price = $3,
    customer_price = $4,
    updated_at = CURRENT_TIMESTAMP
WHERE id = $1 AND deleted_at IS NULL
RETURNING *;

-- name: UpdateProductStatus :one
UPDATE istanahp.products
SET 
    is_active = $2,
    updated_at = CURRENT_TIMESTAMP
WHERE id = $1 AND deleted_at IS NULL
RETURNING *;

-- name: SoftDeleteProduct :exec
UPDATE istanahp.products
SET 
    deleted_at = CURRENT_TIMESTAMP,
    updated_at = CURRENT_TIMESTAMP
WHERE id = $1;

-- name: DeleteProduct :exec
DELETE FROM istanahp.products
WHERE id = $1;

-- name: CountProducts :one
SELECT COUNT(*) FROM istanahp.products
WHERE deleted_at IS NULL;

-- name: CountActiveProducts :one
SELECT COUNT(*) FROM istanahp.products
WHERE is_active = TRUE AND deleted_at IS NULL;

-- name: GetLowStockProducts :many
SELECT p.*, il.current_stock 
FROM istanahp.products p
JOIN istanahp.inventory_levels il ON p.id = il.product_id
WHERE p.reorder_level > 0 
  AND il.current_stock <= p.reorder_level 
  AND p.is_active = TRUE 
  AND p.deleted_at IS NULL
ORDER BY p.name ASC;

