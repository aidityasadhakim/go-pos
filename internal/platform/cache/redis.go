// Package cache provides Redis cache functionality.
package cache

import (
	"context"
	"fmt"
	"net/url"
	"os"
	"strconv"
	"time"

	"github.com/redis/go-redis/v9"
)

var RedisClient *redis.Client

func InitRedis() error {
	redisURL := os.Getenv("REDIS_URL")
	if redisURL == "" {
		return fmt.Errorf("REDIS_URL environment variable is required")
	}

	// Parse Redis URL (e.g., redis://redis:6379/0)
	parsedURL, err := url.Parse(redisURL)
	if err != nil {
		return fmt.Errorf("invalid REDIS_URL format: %w", err)
	}

	// Extract components
	host := parsedURL.Hostname()
	port := parsedURL.Port()
	if port == "" {
		port = "6379" // Default Redis port
	}

	db := 0
	if parsedURL.Path != "" && len(parsedURL.Path) > 1 {
		if dbNum, err := strconv.Atoi(parsedURL.Path[1:]); err == nil {
			db = dbNum
		}
	}

	password := ""
	if parsedURL.User != nil {
		password, _ = parsedURL.User.Password()
	}

	// Override with env var if set
	if envPassword := os.Getenv("REDIS_PASSWORD"); envPassword != "" {
		password = envPassword
	}

	// Create a new Redis client
	RedisClient = redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:%s", host, port),
		Password: password,
		DB:       db,
	})

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// Test the connection
	if err := RedisClient.Ping(ctx).Err(); err != nil {
		return fmt.Errorf("failed to connect to Redis: %w", err)
	}

	return nil
}

func CloseRedis() error {
	if RedisClient != nil {
		return RedisClient.Close()
	}
	return nil
}
