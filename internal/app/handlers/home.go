// Package handlers is the file that contains the HomeHandler and its methods for handling requests related to the home page and click events.
package handlers

import (
	"net/http"

	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/labstack/echo/v4"
)

type HomeHandler struct {
	queries *database.Queries
}

func NewHomeHandler(queries *database.Queries) *HomeHandler {
	return &HomeHandler{queries: queries}
}

func (h *HomeHandler) Home(c echo.Context) error {
	return c.Render(http.StatusOK, "home.html", nil)
}

func (h *HomeHandler) Clicked(c echo.Context) error {
	user, err := h.queries.GetUserByUsername(c.Request().Context(), "superadmin")
	if err != nil {
		return c.String(http.StatusInternalServerError, "Failed to retrieve user")
	}
	return c.HTML(http.StatusOK, "<h1>"+user.Username+"</h1>")
}
