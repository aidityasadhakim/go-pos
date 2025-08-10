.PHONY: help build run dev test clean deps sqlc docker-up docker-down docker-logs seed css install lint fmt vet tidy

# Default target
help: ## Show this help message
	@echo "Go POS System - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Variables
APP_NAME := go-pos
BUILD_DIR := ./bin
MAIN_PATH := ./cmd/main.go
SEED_PATH := ./cmd/seed/main.go
TMP_DIR := ./tmp

# Build targets
build: ## Build the application binary
	@echo "Building $(APP_NAME)..."
	@mkdir -p $(BUILD_DIR)
	@go build -o $(BUILD_DIR)/$(APP_NAME) $(MAIN_PATH)
	@echo "Build complete: $(BUILD_DIR)/$(APP_NAME)"

build-seed: ## Build the seed binary
	@echo "Building seed binary..."
	@mkdir -p $(BUILD_DIR)
	@go build -o $(BUILD_DIR)/seed $(SEED_PATH)
	@echo "Seed build complete: $(BUILD_DIR)/seed"

# Development targets
dev: ## Start development server with hot reload (requires air)
	@echo "Starting development server with hot reload..."
	@air

run: build ## Build and run the application
	@echo "Running $(APP_NAME)..."
	@$(BUILD_DIR)/$(APP_NAME)

seed: build-seed ## Build and run database seeder
	@echo "Running database seeder..."
	@$(BUILD_DIR)/seed

# Dependencies
deps: ## Download and install Go dependencies
	@echo "Installing Go dependencies..."
	@go mod download
	@go mod verify

install: deps ## Install all dependencies (Go + Node.js)
	@echo "Installing Node.js dependencies..."
	@npm install

# CSS/Frontend
css: ## Build Tailwind CSS
	@echo "Building Tailwind CSS..."
	@npx tailwindcss -i ./public/css/input.css -o ./public/css/output.css

css-watch: ## Watch and build Tailwind CSS
	@echo "Watching Tailwind CSS changes..."
	@npx tailwindcss -i ./public/css/input.css -o ./public/css/output.css --watch

# Database
sqlc: ## Generate Go code from SQL
	@echo "Generating Go code from SQL..."
	@sqlc generate

# Testing
test: ## Run tests
	@echo "Running tests..."
	@go test -v ./...

# Docker
docker-up: ## Start Docker containers
	@echo "Starting Docker containers..."
	@docker compose up -d

docker-down: ## Stop Docker containers
	@echo "Stopping Docker containers..."
	@docker compose down

docker-logs: ## Show Docker container logs
	@docker logs go-pos-app -f

docker-rebuild: ## Rebuild and restart Docker containers
	@echo "Rebuilding Docker containers..."
	@docker compose down
	@docker compose build --no-cache
	@docker compose up -d

# Database migrations (if using migrate tool)
migrate-up: ## Run database migrations up
	@echo "Running database migrations..."
	@goose up
migrate-down: ## Run database migrations down
	@echo "Rolling back database migrations..."
	@goose down-to 0

# Cleanup
clean: ## Clean build artifacts and temporary files
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@rm -rf $(TMP_DIR)
	@rm -f coverage.out coverage.html
	@echo "Clean complete"

clean-all: clean ## Clean everything including Docker volumes
	@echo "Cleaning Docker volumes..."
	@docker compose down -v
	@docker system prune -f

# Production
build-prod: ## Build for production
	@echo "Building for production..."
	@mkdir -p $(BUILD_DIR)
	@CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o $(BUILD_DIR)/$(APP_NAME) $(MAIN_PATH)
	@echo "Production build complete: $(BUILD_DIR)/$(APP_NAME)"

# Development workflow
setup: install sqlc css ## Complete development environment setup
	@echo "Development environment setup complete!"
	@echo "Run 'make dev' to start development server"

# Quick commands
start: docker-up ## Start everything (Docker + dev server)

stop: docker-down ## Stop all services

restart: docker-down docker-up ## Restart Docker services
