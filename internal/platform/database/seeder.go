package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	"golang.org/x/crypto/bcrypt"
)

type Seeder struct {
	db *sql.DB
}

func NewSeeder(db *sql.DB) *Seeder {
	return &Seeder{db: db}
}

func (s *Seeder) SeedAll() error {
	log.Println("Starting database seeding...")

	if err := s.seedRoles(); err != nil {
		return fmt.Errorf("failed to seed roles: %w", err)
	}

	if err := s.seedSuperAdmin(); err != nil {
		return fmt.Errorf("failed to seed superadmin: %w", err)
	}

	if err := s.seedProductCategories(); err != nil {
		return fmt.Errorf("failed to seed product categories: %w", err)
	}

	log.Println("Database seeding completed successfully!")
	return nil
}

func (s *Seeder) seedRoles() error {
	log.Println("Seeding roles...")

	roles := []struct {
		name        string
		description string
	}{
		{"superadmin", "Super Administrator with full system access"},
		{"admin", "Administrator with management privileges"},
		{"employee", "Employee with limited access"},
	}

	for _, role := range roles {
		query := `
			INSERT INTO istanahp.roles (name, description)
			VALUES ($1, $2)
			ON CONFLICT (name) DO NOTHING
		`
		_, err := s.db.Exec(query, role.name, role.description)
		if err != nil {
			return fmt.Errorf("failed to insert role %s: %w", role.name, err)
		}
		log.Printf("Role '%s' seeded successfully", role.name)
	}

	return nil
}

func (s *Seeder) seedSuperAdmin() error {
	log.Println("Seeding superadmin user...")

	if err := godotenv.Load(".env"); err != nil {
		log.Println("No .env file found, using system environment variables")
	}

	// Check if superadmin already exists
	var count int
	checkQuery := `
		SELECT COUNT(*) FROM istanahp.users u
		JOIN istanahp.roles r ON u.role_id = r.id
		WHERE r.name = 'superadmin'
	`
	err := s.db.QueryRow(checkQuery).Scan(&count)
	if err != nil {
		return fmt.Errorf("failed to check existing superadmin: %w", err)
	}

	if count > 0 {
		log.Println("Superadmin user already exists, skipping...")
		return nil
	}

	// Get superadmin role ID
	var roleID int64
	roleQuery := `SELECT id FROM istanahp.roles WHERE name = 'superadmin'`
	err = s.db.QueryRow(roleQuery).Scan(&roleID)
	if err != nil {
		return fmt.Errorf("failed to get superadmin role ID: %w", err)
	}

	// Hash default password
	defaultPassword := os.Getenv("SUPER_ADMIN_PASSWORD") // Change this in production
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(defaultPassword), bcrypt.DefaultCost)
	if err != nil {
		return fmt.Errorf("failed to hash password: %w", err)
	}

	// Create superadmin user
	userQuery := `
		INSERT INTO istanahp.users (role_id, name, username, password_hash, email, is_active)
		VALUES ($1, $2, $3, $4, $5, $6)
	`
	_, err = s.db.Exec(userQuery, roleID, "Super Administrator", "superadmin", string(hashedPassword), nil, true)
	if err != nil {
		return fmt.Errorf("failed to create superadmin user: %w", err)
	}

	log.Println("Superadmin user created successfully")
	log.Printf("Username: superadmin")
	log.Printf("Password: %s", defaultPassword)
	log.Println("⚠️  Please change the default password after first login!")

	return nil
}

func (s *Seeder) seedProductCategories() error {
	log.Println("Seeding product categories...")

	categories := []string{
		"Accessories",
		"Part",
		"Unit",
		"Tools",
	}

	for _, category := range categories {
		query := `
			INSERT INTO istanahp.product_categories (name)
			VALUES ($1)
			ON CONFLICT (name) DO NOTHING
		`
		_, err := s.db.Exec(query, category)
		if err != nil {
			return fmt.Errorf("failed to insert category %s: %w", category, err)
		}
		log.Printf("Category '%s' seeded successfully", category)
	}

	return nil
}
