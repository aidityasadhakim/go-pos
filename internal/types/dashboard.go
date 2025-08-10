package types

type DashboardData struct {
	UserName      string
	UserRole      string
	UserLevel     int64
	TodaySales    string
	ProductCount  int64
	CustomerCount int64
}

// Implement User interface
func (d DashboardData) GetUserID() string {
	return ""
}

func (d DashboardData) GetUsername() string {
	return d.UserName
}

func (d DashboardData) GetUserRole() int64 {
	return d.UserLevel
}
