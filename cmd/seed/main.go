package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"github.com/aidityasadhakim/go-pos/internal/platform/database"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using system environment variables")
	}

	// Get database connection string from environment
	dbURL := os.Getenv("DB_STRING")
	if dbURL == "" {
		log.Fatal("DATABASE_URL environment variable is required")
	}

	// Connect to database
	db, err := sql.Open("postgres", dbURL)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()

	// Test database connection
	if err := db.Ping(); err != nil {
		log.Fatalf("Failed to ping database: %v", err)
	}

	// Create and run seeder
	seeder := database.NewSeeder(db)
	if err := seeder.SeedAll(); err != nil {
		log.Fatalf("Seeding failed: %v", err)
	}

	fmt.Println("✅ Database seeding completed successfully!")
}
