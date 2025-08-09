package handlers

import (
	"context"
	"database/sql"

	"github.com/aidityasadhakim/go-pos/internal/app/middleware"
	"github.com/aidityasadhakim/go-pos/internal/app/services"
	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/labstack/echo/v4"
)

type ProductsHandler struct {
	queries        *database.Queries
	db             *sql.DB
	ProductService *services.ProductService
}

type ProductsPageData struct {
	UserName         string
	UserRole         string
	UserLevel        int64
	IstanaHpProducts []database.IstanahpProduct
	Categories       []database.IstanahpProductCategory
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

	productCategories, err := h.queries.GetProductCategories(context.Background())

	data := ProductsPageData{
		UserName:         user.Username,
		UserRole:         middleware.GetRoleName(user.RoleID),
		UserLevel:        user.RoleID,
		IstanaHpProducts: products,
		Categories:       productCategories,
	}

	return c.Render(200, "products.html", data)
}
