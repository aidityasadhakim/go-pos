package handlers

import (
	"context"
	"net/http"

	"github.com/aidityasadhakim/go-pos/internal/app/middleware"
	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/aidityasadhakim/go-pos/internal/platform/session"
	"github.com/labstack/echo/v4"
	"golang.org/x/crypto/bcrypt"
)

type AuthHandler struct {
	queries *database.Queries
}

func NewAuthHandler(queries *database.Queries) *AuthHandler {
	return &AuthHandler{queries: queries}
}

func (h *AuthHandler) Login(c echo.Context) error {
	if middleware.GetSessionUser(c) != nil {
		return c.Redirect(http.StatusSeeOther, "/")
	}
	return c.Render(http.StatusOK, "login.html", nil)
}

func (h *AuthHandler) Authenticate(c echo.Context) error {
	username := c.FormValue("username")
	password := c.FormValue("password")

	if username == "" || password == "" {
		return c.HTML(http.StatusBadRequest, `<div class="text-red-600 text-sm">Username and password are required</div>`)
	}

	user, err := h.queries.GetUserByUsername(context.Background(), username)
	if err != nil {
		return c.HTML(http.StatusUnauthorized, `<div class="text-red-600 text-sm">Invalid username or password</div>`)
	}

	if !user.IsActive {
		return c.HTML(http.StatusUnauthorized, `<div class="text-red-600 text-sm">Account is disabled</div>`)
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password))
	if err != nil {
		return c.HTML(http.StatusUnauthorized, `<div class="text-red-600 text-sm">Invalid username or password</div>`)
	}

	token, err := session.Create(context.Background(), user.ID, user.Username, user.RoleID)
	if err != nil {
		return c.HTML(http.StatusInternalServerError, `<div class="text-red-600 text-sm">Login failed. Please try again.</div>`)
	}

	session.SetCookie(c, token)
	c.Response().Header().Set("HX-Redirect", "/")
	return c.NoContent(http.StatusOK)
}

func (h *AuthHandler) Logout(c echo.Context) error {
	token := session.GetTokenFromCookie(c)
	if token != "" {
		session.Delete(context.Background(), token)
	}
	session.ClearCookie(c)
	return c.Redirect(http.StatusSeeOther, "/")
}
