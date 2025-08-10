// Package services provides the implementation of product-related services.
package services

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/aidityasadhakim/go-pos/internal/platform/database"
)

type ProductService struct {
	queries *database.Queries
	db      *sql.DB
}

type CreateProductRequest struct {
	CategoryID    int64          `form:"category_id"`
	Name          string         `form:"name"`
	SKU           string         `form:"sku"`
	Barcode       *string        `form:"barcode,omitempty"`
	Description   sql.NullString `form:"description,omitempty"`
	RetailPrice   string         `form:"retail_price"`
	CustomerPrice string         `form:"customer_price"`
	ReorderLevel  int32          `form:"reorder_level"`
	IsActive      bool           `form:"is_active"`
}

type UpdateProductRequest struct {
	ID            int64          `form:"id"`
	CategoryID    int64          `form:"category_id"`
	Name          string         `form:"name"`
	SKU           string         `form:"sku"`
	Barcode       *string        `form:"barcode,omitempty"`
	Description   sql.NullString `form:"description,omitempty"`
	RetailPrice   string         `form:"retail_price"`
	CustomerPrice string         `form:"customer_price"`
	ReorderLevel  int32          `form:"reorder_level"`
	IsActive      bool           `form:"is_active"`
}

type SearchProductsRequest struct {
	Query  string `form:"query"`
	Limit  int32  `form:"limit"`
	Offset int32  `form:"offset"`
}

func NewProductService(queries *database.Queries, db *sql.DB) *ProductService {
	return &ProductService{
		queries: queries,
		db:      db,
	}
}

func (s *ProductService) CreateProduct(ctx context.Context, req CreateProductRequest) (*database.IstanahpProduct, error) {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to begin transaction: %w", err)
	}
	defer tx.Rollback()

	qtx := s.queries.WithTx(tx)

	product, err := qtx.CreateProduct(ctx, database.CreateProductParams{
		CategoryID:    req.CategoryID,
		Name:          req.Name,
		Sku:           req.SKU,
		Description:   req.Description,
		RetailPrice:   req.RetailPrice,
		CustomerPrice: req.CustomerPrice,
		ReorderLevel:  req.ReorderLevel,
		IsActive:      req.IsActive,
	})
	if err != nil {
		return nil, fmt.Errorf("failed to create product: %w", err)
	}

	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("failed to commit transaction: %w", err)
	}

	return &product, nil
}

// func (s *ProductService) GetProduct(ctx context.Context, id int64) (*database.IstanahpProduct, error) {
// 	product, err := s.queries.GetProduct(ctx, id)
// 	if err != nil {
// 		return nil, fmt.Errorf("failed to get product: %w", err)
// 	}
// 	return &product, nil
// }

// func (s *ProductService) GetProductBySKU(ctx context.Context, sku string) (*database.IstanahpProduct, error) {
// 	product, err := s.queries.GetProductBySKU(ctx, sku)
// 	if err != nil {
// 		return nil, fmt.Errorf("failed to get product by SKU: %w", err)
// 	}
// 	return &product, nil
// }

// func (s *ProductService) UpdateProduct(ctx context.Context, req UpdateProductRequest) (*database.IstanahpProduct, error) {
// 	product, err := s.queries.UpdateProduct(ctx, database.UpdateProductParams{
// 		ID:            req.ID,
// 		CategoryID:    req.CategoryID,
// 		Name:          req.Name,
// 		Sku:           req.SKU,
// 		Description:   req.Description,
// 		RetailPrice:   req.RetailPrice,
// 		CustomerPrice: req.CustomerPrice,
// 		ReorderLevel:  req.ReorderLevel,
// 		IsActive:      req.IsActive,
// 	})
// 	if err != nil {
// 		return nil, fmt.Errorf("failed to update product: %w", err)
// 	}
// 	return &product, nil
// }
//
// func (s *ProductService) DeleteProduct(ctx context.Context, id int64) error {
// 	if err := s.queries.SoftDeleteProduct(ctx, id); err != nil {
// 		return fmt.Errorf("failed to delete product: %w", err)
// 	}
// 	return nil
// }

// func (s *ProductService) ListProducts(ctx context.Context, limit, offset int32) ([]database.IstanahpProduct, error) {
// 	products, err := s.queries.ListProducts(ctx, database.ListProductsParams{
// 		Limit:  limit,
// 		Offset: offset,
// 	})
// 	if err != nil {
// 		return nil, fmt.Errorf("failed to list products: %w", err)
// 	}
// 	return products, nil
// }
//
// func (s *ProductService) ListActiveProducts(ctx context.Context) ([]database.IstanahpProduct, error) {
// 	products, err := s.queries.ListActiveProducts(ctx)
// 	if err != nil {
// 		return nil, fmt.Errorf("failed to list active products: %w", err)
// 	}
// 	return products, nil
// }

// func (s *ProductService) SearchProducts(ctx context.Context, req SearchProductsRequest) ([]database.IstanahpProduct, error) {
// 	products, err := s.queries.SearchProducts(ctx, database.SearchProductsParams{
// 		Column1: req.Query,
// 		Limit:   req.Limit,
// 		Offset:  req.Offset,
// 	})
// 	if err != nil {
// 		return nil, fmt.Errorf("failed to search products: %w", err)
// 	}
// 	return products, nil
// }
//
// func (s *ProductService) CountProducts(ctx context.Context) (int64, error) {
// 	count, err := s.queries.CountProducts(ctx)
// 	if err != nil {
// 		return 0, fmt.Errorf("failed to count products: %w", err)
// 	}
// 	return count, nil
// }
//
// func (s *ProductService) CountActiveProducts(ctx context.Context) (int64, error) {
// 	count, err := s.queries.CountActiveProducts(ctx)
// 	if err != nil {
// 		return 0, fmt.Errorf("failed to count active products: %w", err)
// 	}
// 	return count, nil
// }
