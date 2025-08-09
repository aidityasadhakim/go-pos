package main

import (
	"log"

	"github.com/aidityasadhakim/go-pos/internal/app/routes"
	"github.com/aidityasadhakim/go-pos/internal/platform/cache"
	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/aidityasadhakim/go-pos/internal/platform/server"
	"github.com/joho/godotenv"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	godotenv.Load(".env")

	// Initialize database
	queries, err := database.Connect()
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	// Initialize Redis
	if err := cache.InitRedis(); err != nil {
		log.Fatal("Failed to connect to Redis:", err)
	}

	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	// Setup template renderer
	renderer := server.NewTemplateRenderer("web/template")
	e.Renderer = renderer

	// Setup routes
	routes.SetupRoutes(e, queries)

	e.Logger.Fatal(e.Start(":8080"))
}
