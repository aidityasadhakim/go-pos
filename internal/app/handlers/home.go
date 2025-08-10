// Package handlers // handles the HTTP requests for the home page and dashboard.
package handlers

import (
	"database/sql"
	"net/http"

	"github.com/aidityasadhakim/go-pos/internal/app/middleware"
	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/aidityasadhakim/go-pos/internal/platform/server"
	"github.com/aidityasadhakim/go-pos/internal/types"
	"github.com/aidityasadhakim/go-pos/views/pages"
	"github.com/labstack/echo/v4"
)

type HomeHandler struct {
	queries *database.Queries
	db      *sql.DB
}

type DashboardData = types.DashboardData

func NewHomeHandler(queries *database.Queries, db *sql.DB) *HomeHandler {
	return &HomeHandler{
		queries: queries,
		db:      db,
	}
}

func (h *HomeHandler) Home(c echo.Context) error {
	// Get user session
	sessionUser := middleware.GetSessionUser(c)
	if sessionUser == nil {
		return c.Redirect(http.StatusFound, "/login")
	}

	// Prepare template data with session info
	data := types.DashboardData{
		UserName:      sessionUser.Username, // For now, use username until we have full name
		UserRole:      middleware.GetRoleName(sessionUser.RoleID),
		UserLevel:     sessionUser.RoleID,
		TodaySales:    "$0.00", // TODO: Implement today's sales calculation
		ProductCount:  0,       // TODO: Will be available after SQLC generation
		CustomerCount: 0,       // TODO: Will be available after SQLC generation
	}

	return server.RenderTempl(c, pages.Home(data))
}

func (h *HomeHandler) Clicked(c echo.Context) error {
	sessionUser := middleware.GetSessionUser(c)
	if sessionUser == nil {
		return c.String(http.StatusUnauthorized, "Not authenticated")
	}

	return c.HTML(http.StatusOK, "<h1>Hello, "+sessionUser.Username+"!</h1>")
}
