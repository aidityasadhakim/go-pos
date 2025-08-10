package handlers

import (
	"context"
	"database/sql"

	"github.com/aidityasadhakim/go-pos/internal/app/middleware"
	"github.com/aidityasadhakim/go-pos/internal/app/services"
	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/aidityasadhakim/go-pos/internal/platform/server"
	"github.com/aidityasadhakim/go-pos/internal/types"
	"github.com/aidityasadhakim/go-pos/views/pages/product"
	"github.com/labstack/echo/v4"
)

type ProductsHandler struct {
	queries        *database.Queries
	db             *sql.DB
	ProductService *services.ProductService
}

type ProductCreateData struct {
	UserName   string
	UserRole   string
	UserLevel  int64
	Categories []database.GetProductCategoriesRow
}

func NewProductsHandler(queries *database.Queries, db *sql.DB) *ProductsHandler {
	// Initialize the ProductService with the provided queries
	productService := services.NewProductService(queries, db)
	return &ProductsHandler{queries: queries, db: db, ProductService: productService}
}

func (h *ProductsHandler) Index(c echo.Context) error {
	user := middleware.GetSessionUser(c)

	if user == nil {
		return c.Redirect(302, "/login")
	}

	limit, offset := 10, 0 // Default values for pagination
	products, err := h.queries.ListProducts(context.Background(), database.ListProductsParams{
		Limit:  int32(limit),
		Offset: int32(offset),
	})
	if err != nil {
		return c.HTML(400, "Error fetching products: "+err.Error())
	}

	data := types.ProductsPageData{
		UserName:  user.Username,
		UserRole:  middleware.GetRoleName(user.RoleID),
		UserLevel: user.RoleID,
		Products:  products,
	}

	return server.RenderTempl(c, product.Index(data))
}

// func (h *ProductsHandler) Create(c echo.Context) error {
// 	user := middleware.GetSessionUser(c)
//
// 	if user == nil {
// 		return c.Redirect(302, "/login")
// 	}
//
// 	productCategories, err := h.queries.GetProductCategories(context.Background())
// 	if err != nil {
// 		return c.HTML(400, "Error fetching product categories: "+err.Error())
// 	}
//
// 	data := ProductCreateData{
// 		UserName:   user.Username,
// 		UserRole:   middleware.GetRoleName(user.RoleID),
// 		UserLevel:  user.RoleID,
// 		Categories: productCategories,
// 	}
//
// 	return c.Render(200, "add-product.html", data)
// }
//
// func (h *ProductsHandler) Store(c echo.Context) error {
// 	user := middleware.GetSessionUser(c)
//
// 	if user == nil {
// 		return c.Redirect(302, "/login")
// 	}
//
// 	var product services.CreateProductRequest
//
// 	if err := c.Bind(&product); err != nil {
// 		return c.HTML(400, "Error binding product data: "+err.Error())
// 	}
//
// 	if _, err := h.ProductService.CreateProduct(c.Request().Context(), product); err != nil {
// 		return c.HTML(400, "Error creating product: "+err.Error())
// 	}
//
// 	return c.Redirect(302, "/products")
// }
