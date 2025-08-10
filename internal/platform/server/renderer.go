// Package server // provides utility functions for rendering templates in the Echo framework.
package server

import (
	"context"

	"github.com/a-h/templ"
	"github.com/labstack/echo/v4"
)

func RenderTempl(c echo.Context, component templ.Component) error {
	return component.Render(context.Background(), c.Response().Writer)
}
