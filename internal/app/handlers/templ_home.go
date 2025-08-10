package handlers

import (
	"context"
	"database/sql"
	"net/http"

	"github.com/a-h/templ"
	"github.com/aidityasadhakim/go-pos/internal/app/middleware"
	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/aidityasadhakim/go-pos/internal/types"
	"github.com/aidityasadhakim/go-pos/views/pages"
	"github.com/labstack/echo/v4"
)

type TemplHomeHandler struct {
	queries *database.Queries
	db      *sql.DB
}

func NewTemplHomeHandler(queries *database.Queries, db *sql.DB) *TemplHomeHandler {
	return &TemplHomeHandler{
		queries: queries,
		db:      db,
	}
}

func renderTempl(c echo.Context, component templ.Component) error {
	return component.Render(context.Background(), c.Response().Writer)
}

func (h *TemplHomeHandler) Home(c echo.Context) error {
	sessionUser := middleware.GetSessionUser(c)
	if sessionUser == nil {
		return c.Redirect(http.StatusFound, "/login")
	}

	data := types.DashboardData{
		UserName:      sessionUser.Username,
		UserRole:      middleware.GetRoleName(sessionUser.RoleID),
		UserLevel:     sessionUser.RoleID,
		TodaySales:    "$0.00",
		ProductCount:  0,
		CustomerCount: 0,
	}

	return renderTempl(c, pages.Home(data))
}

func (h *TemplHomeHandler) Clicked(c echo.Context) error {
	sessionUser := middleware.GetSessionUser(c)
	if sessionUser == nil {
		return c.String(http.StatusUnauthorized, "Not authenticated")
	}

	return c.HTML(http.StatusOK, "<h1>Hello, "+sessionUser.Username+"! (from Templ)</h1>")
}
