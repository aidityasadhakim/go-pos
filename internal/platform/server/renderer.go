package server

import (
	"html/template"
	"io"
	"path/filepath"

	"github.com/labstack/echo/v4"
)

type TemplateRenderer struct {
	templates *template.Template
}

func NewTemplateRenderer(templateDir string) *TemplateRenderer {
	templates := template.Must(template.ParseGlob(filepath.Join(templateDir, "*.html")))
	templates := template.Must(template.ParseGlob(filepath.Join(templateDir, "views/*.html")))

	return &TemplateRenderer{
		templates: templates,
	}
}

func (t *TemplateRenderer) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	return t.templates.ExecuteTemplate(w, name, data)
}
