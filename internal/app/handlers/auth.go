package handlers

import (
	"net/http"

	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/labstack/echo/v4"
)

type AuthHandler struct {
	queries *database.Queries
}

func NewAuthHandler(queries *database.Queries) *AuthHandler {
	return &AuthHandler{queries: queries}
}

func (h *AuthHandler) Login(c echo.Context) error {
	return c.Render(http.StatusOK, "login.html", nil)
}

func (h *AuthHandler) Authenticate(c echo.Context) error {
	return nil
}

func (h *AuthHandler) Logout(c echo.Context) error {
	// Here you would typically clear the session or token
	// For simplicity, we just redirect to the home page
	return c.Redirect(http.StatusSeeOther, "/")
}
