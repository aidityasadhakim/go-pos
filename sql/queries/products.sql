-- name: CreateProduct :one
INSERT INTO istanahp.products (
    category_id,
    name,
    sku,
    description,
    retail_price,
    customer_price,
    reorder_level,
    is_active
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
) RETURNING *;

-- name: GetProduct :one
SELECT * FROM istanahp.products
WHERE id = $1 AND deleted_at IS NULL;

-- name: GetProductBySKU :one
SELECT * FROM istanahp.products
WHERE sku = $1 AND deleted_at IS NULL;

-- name: ListProducts :many
select 
	p.id,
	p.name,
	pc.name as category_name,
	p.sku,
	p.retail_price,
	p.customer_price,
	p.reorder_level
FROM istanahp.products p
left join istanahp.product_categories pc
	on pc.id = p.category_id
WHERE p.deleted_at IS null and is_active = true
ORDER BY p.created_at desc
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
    name = $3,
    sku = $4,
    description = $5,
    retail_price = $6,
    customer_price = $7,
    reorder_level = $8,
    is_active = $9,
    updated_at = CURRENT_TIMESTAMP
WHERE id = $1 AND deleted_at IS NULL
RETURNING *;

-- name: UpdateProductPrice :one
UPDATE istanahp.products
SET 
    retail_price = $2,
    customer_price = $3,
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

-- name: CreateProductCostLot :one
INSERT INTO istanahp.product_cost_lots (
    product_id,
    quantity,
    unit_cost,
    purchase_item_id,
    received_at,
    expires_at
) VALUES (
    $1, $2, $3, $4, $5, $6
) RETURNING *;

-- name: GetProductCostLot :one
SELECT * FROM istanahp.product_cost_lots
WHERE id = $1;

-- name: ListProductCostLots :many
SELECT * FROM istanahp.product_cost_lots
WHERE product_id = $1 AND quantity > 0
ORDER BY received_at ASC; -- FIFO ordering

-- name: GetOldestCostLot :one
SELECT * FROM istanahp.product_cost_lots
WHERE product_id = $1 AND quantity > 0
ORDER BY received_at ASC
LIMIT 1;

-- name: UpdateCostLotQuantity :one
UPDATE istanahp.product_cost_lots
SET 
    quantity = $2,
    updated_at = CURRENT_TIMESTAMP
WHERE id = $1
RETURNING *;

-- name: GetProductCostSummary :one
SELECT 
    p.id,
    p.name,
    p.sku,
    COALESCE(SUM(pcl.quantity), 0) as total_quantity,
    COALESCE(SUM(pcl.quantity * pcl.unit_cost), 0) as total_value,
    CASE 
        WHEN SUM(pcl.quantity) > 0 
        THEN SUM(pcl.quantity * pcl.unit_cost) / SUM(pcl.quantity)
        ELSE 0 
    END as weighted_avg_cost
FROM istanahp.products p
LEFT JOIN istanahp.product_cost_lots pcl ON p.id = pcl.product_id AND pcl.quantity > 0
WHERE p.id = $1 AND p.deleted_at IS NULL
GROUP BY p.id, p.name, p.sku;

-- name: GetExpiredCostLots :many
SELECT * FROM istanahp.product_cost_lots
WHERE expires_at IS NOT NULL 
  AND expires_at < CURRENT_DATE 
  AND quantity > 0
ORDER BY expires_at ASC;

-- name: GetCostLotsByDateRange :many
SELECT pcl.*, p.name as product_name, p.sku
FROM istanahp.product_cost_lots pcl
JOIN istanahp.products p ON pcl.product_id = p.id
WHERE pcl.received_at BETWEEN $1 AND $2
ORDER BY pcl.received_at DESC;

-- name: GetProductCategories :many
SELECT id, name FROM istanahp.product_categories
WHERE deleted_at IS NULL;
