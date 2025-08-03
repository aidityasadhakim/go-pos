package routes

import (
	"github.com/aidityasadhakim/go-pos/internal/app/handlers"
	"github.com/labstack/echo/v4"
)

func SetupRoutes(e *echo.Echo) {
	// Serve static files
	e.Static("/js", "web/js")

	homeHandler := handlers.NewHomeHandler()
	authHandler := handlers.NewAuthHandler()
	e.GET("/", homeHandler.Home)
	e.GET("/login", authHandler.Login)
	e.GET("/logout", authHandler.Logout)
	e.GET("/clicked", homeHandler.Clicked)
}
