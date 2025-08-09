package routes

import (
	"database/sql"

	"github.com/aidityasadhakim/go-pos/internal/app/handlers"
	"github.com/aidityasadhakim/go-pos/internal/app/middleware"
	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/labstack/echo/v4"
)

func SetupRoutes(e *echo.Echo, queries *database.Queries, db *sql.DB) {
	// Apply session middleware globally
	e.Use(middleware.SessionMiddleware())

	// Serve static files from public directory
	e.Static("/css", "public/css")
	e.Static("/js", "public/js")
	e.Static("/img", "public/img")

	homeHandler := handlers.NewHomeHandler(queries, db)
	authHandler := handlers.NewAuthHandler(queries, db)
	productsHandler := handlers.NewProductsHandler(queries, db)

	// Public routes
	e.GET("/login", authHandler.Login)
	e.POST("/login", authHandler.Authenticate)
	e.GET("/logout", authHandler.Logout)

	// Protected routes
	protected := e.Group("", middleware.RequireAuth())
	protected.GET("/", homeHandler.Home)
	protected.GET("/clicked", homeHandler.Clicked)
	protected.GET("/products", productsHandler.Index)
}
