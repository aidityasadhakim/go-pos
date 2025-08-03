package handlers

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

type HomeHandler struct{}

func NewHomeHandler() *HomeHandler {
	return &HomeHandler{}
}

func (h *HomeHandler) Home(c echo.Context) error {
	return c.Render(http.StatusOK, "home.html", nil)
}

func (h *HomeHandler) Clicked(c echo.Context) error {
	// return a simple html says "Clicked"
	return c.HTML(http.StatusOK, "<h1>Clicked!</h1>")
}
