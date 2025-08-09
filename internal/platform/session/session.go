// Package session provides functionality for managing user sessions using Redis.
package session

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"net/http"
	"time"

	"github.com/aidityasadhakim/go-pos/internal/platform/cache"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

const (
	sessionCookieName = "session_token"
	sessionExpiry     = 24 * time.Hour
	sessionKeyPrefix  = "session:"
)

type Session struct {
	UserID   uuid.UUID `json:"user_id"`
	Username string    `json:"username"`
	RoleID   int64     `json:"role_id"`
	IssuedAt time.Time `json:"issued_at"`
}

func generateToken() (string, error) {
	bytes := make([]byte, 32)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

func Create(ctx context.Context, userID uuid.UUID, username string, roleID int64) (string, error) {
	token, err := generateToken()
	if err != nil {
		return "", err
	}

	session := Session{
		UserID:   userID,
		Username: username,
		RoleID:   roleID,
		IssuedAt: time.Now(),
	}

	data, err := json.Marshal(session)
	if err != nil {
		return "", err
	}

	key := sessionKeyPrefix + token
	err = cache.RedisClient.Set(ctx, key, data, sessionExpiry).Err()
	if err != nil {
		return "", err
	}

	return token, nil
}

func Get(ctx context.Context, token string) (*Session, error) {
	if token == "" {
		return nil, nil
	}

	key := sessionKeyPrefix + token
	data, err := cache.RedisClient.Get(ctx, key).Result()
	if err != nil {
		return nil, err
	}

	var session Session
	err = json.Unmarshal([]byte(data), &session)
	if err != nil {
		return nil, err
	}

	return &session, nil
}

func Delete(ctx context.Context, token string) error {
	if token == "" {
		return nil
	}

	key := sessionKeyPrefix + token
	return cache.RedisClient.Del(ctx, key).Err()
}

func SetCookie(c echo.Context, token string) {
	cookie := &http.Cookie{
		Name:     sessionCookieName,
		Value:    token,
		Path:     "/",
		HttpOnly: true,
		Secure:   false, // Set to true in production with HTTPS
		SameSite: http.SameSiteStrictMode,
		Expires:  time.Now().Add(sessionExpiry),
	}
	c.SetCookie(cookie)
}

func GetTokenFromCookie(c echo.Context) string {
	cookie, err := c.Cookie(sessionCookieName)
	if err != nil {
		return ""
	}
	return cookie.Value
}

func ClearCookie(c echo.Context) {
	cookie := &http.Cookie{
		Name:     sessionCookieName,
		Value:    "",
		Path:     "/",
		HttpOnly: true,
		Expires:  time.Now().Add(-time.Hour),
	}
	c.SetCookie(cookie)
}
