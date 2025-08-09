package middleware

import (
	"context"

	"github.com/aidityasadhakim/go-pos/internal/platform/session"
	"github.com/labstack/echo/v4"
)

const SessionUserKey = "user"

func SessionMiddleware() echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			token := session.GetTokenFromCookie(c)
			if token != "" {
				sess, err := session.Get(context.Background(), token)
				if err == nil && sess != nil {
					c.Set(SessionUserKey, sess)
				}
			}
			return next(c)
		}
	}
}

func RequireAuth() echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			user := c.Get(SessionUserKey)
			if user == nil {
				if c.Request().Header.Get("HX-Request") == "true" {
					c.Response().Header().Set("HX-Redirect", "/login")
					return c.NoContent(204)
				}
				return c.Redirect(302, "/login")
			}
			return next(c)
		}
	}
}

func GetSessionUser(c echo.Context) *session.Session {
	user := c.Get(SessionUserKey)
	if user == nil {
		return nil
	}
	return user.(*session.Session)
}
