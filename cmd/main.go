package main

import (
	"net/http"

	"github.com/joho/godotenv"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	godotenv.Load(".env")

	e := echo.New()
	e.Use(middleware.Logger())
	e.GET("/", func(c echo.Context) error {

		return c.JSON(http.StatusOK, map[string]string{
			"message": "Welcome to the Go POS API",
		})
	})

	e.Logger.Fatal(e.Start(":8080"))
}
