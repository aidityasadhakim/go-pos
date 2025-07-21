-- +goose up
CREATE TABLE IF NOT EXISTS receipt_templates (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,          -- e.g., 'Standard 80mm', 'Kitchen Ticket'
    header_text TEXT,
    footer_text TEXT,
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    phone VARCHAR(20),
    website VARCHAR(255),
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    page_width_mm INTEGER,               -- Width in millimeters for thermal printers
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);
COMMENT ON TABLE receipt_templates IS 'Configurable templates for printed or digital receipts.';

-- +goose down
DROP TABLE IF EXISTS receipt_templates;
