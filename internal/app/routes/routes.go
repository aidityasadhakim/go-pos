package routes

import (
	"github.com/aidityasadhakim/go-pos/internal/app/handlers"
	"github.com/aidityasadhakim/go-pos/internal/app/middleware"
	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/labstack/echo/v4"
)

func SetupRoutes(e *echo.Echo, queries *database.Queries) {
	// Apply session middleware globally
	e.Use(middleware.SessionMiddleware())

	// Serve static files
	e.Static("/js", "web/js")

	homeHandler := handlers.NewHomeHandler(queries)
	authHandler := handlers.NewAuthHandler(queries)

	// Public routes
	e.GET("/login", authHandler.Login)
	e.POST("/login", authHandler.Authenticate)
	e.GET("/logout", authHandler.Logout)

	// Protected routes
	protected := e.Group("", middleware.RequireAuth())
	protected.GET("/", homeHandler.Home)
	protected.GET("/clicked", homeHandler.Clicked)
}
