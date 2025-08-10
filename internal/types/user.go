package types

type User interface {
	GetUserID() string
	GetUsername() string
	GetUserRole() int64
}
