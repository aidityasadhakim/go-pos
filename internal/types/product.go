package types

import "github.com/aidityasadhakim/go-pos/internal/platform/database"

type ProductsPageData struct {
	UserName  string
	UserRole  string
	UserLevel int64
	Products  []database.ListProductsRow
}

// Implement User interface
func (p ProductsPageData) GetUserID() string {
	return ""
}

func (p ProductsPageData) GetUsername() string {
	return p.UserName
}

func (p ProductsPageData) GetUserRole() int64 {
	return p.UserLevel
}
