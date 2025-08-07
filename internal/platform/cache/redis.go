// Package database provides database connections and clients for PostgreSQL and Redis.
package database

import (
	"context"
	"fmt"
	"net"
	"os"
	"strconv"
	"time"

	"github.com/redis/go-redis/v9"
)

var RedisClient *redis.Client

func InitRedis() error {
	password := os.Getenv("REDIS_PASSWORD")
	redisURL := os.Getenv("REDIS_URL")
	if redisURL == "" {
		return fmt.Errorf("REDIS_URL environment variable is required")
	}

	// Parse the URL to get the host and port
	host, portStr, err := net.SplitHostPort(redisURL)
	if err != nil {
		return fmt.Errorf("invalid REDIS_URL format: %w", err)
	}

	port, err := strconv.Atoi(portStr)
	if err != nil {
		return fmt.Errorf("invalid REDIS_URL port: %w", err)
	}

	// Create a new Redis client
	RedisClient = redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:%d", host, port),
		Password: password,
		DB:       0,
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
