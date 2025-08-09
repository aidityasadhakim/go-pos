package handlers

import (
	"context"
	"net/http"

	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/labstack/echo/v4"
)

type ProductsHandler struct {
	queries *database.Queries
}

func NewProductsHandler(queries *database.Queries) *ProductsHandler {
	return &ProductsHandler{queries: queries}
}

func (h *ProductsHandler) index(c echo.Context) error {
	products, err := h.queries.GetAllProducts(context.Background())
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to fetch products"})
	}

	return c.Render(http.StatusOK, "products/list.html", map[string]interface{}{
		"products": products,
	})
}
