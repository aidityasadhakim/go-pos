package main

import (
	"github.com/aidityasadhakim/go-pos/internal/app/routes"
	"github.com/aidityasadhakim/go-pos/internal/platform/server"
	"github.com/joho/godotenv"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	godotenv.Load(".env")

	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	// Setup template renderer
	renderer := server.NewTemplateRenderer("web/template")
	e.Renderer = renderer

	// Setup routes
	routes.SetupRoutes(e)

	e.Logger.Fatal(e.Start(":8080"))
}
