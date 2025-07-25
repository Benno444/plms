-- PostgreSQL Database Schema for Tool Management System (PLMS)
-- Created: July 25, 2025
-- 19 Tables Total with main 'tools' table connected via UUID foreign keys
-- Uses UUID v4 for all Primary Keys (globally unique IDs)

-- Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================
-- REFERENCE TABLES WITHOUT TOOL DEPENDENCIES (14 tables)
-- =============================================

-- 1. Tool Types
CREATE TABLE tool_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Publication Status
CREATE TABLE publication_status (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Vehicle Types (from Prisma vehicle database)
CREATE TABLE vehicle_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_type VARCHAR(20) NOT NULL UNIQUE,
    description TEXT,
    market_introduction_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Component Groups
CREATE TABLE component_groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tool Categories
CREATE TABLE tool_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Suppliers
CREATE TABLE suppliers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    contact_info TEXT,
    address TEXT,
    email VARCHAR(255),
    phone VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Risk Levels
CREATE TABLE risk_levels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    level VARCHAR(20) NOT NULL UNIQUE,
    color VARCHAR(20) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Technical Specifications
CREATE TABLE technical_specifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Units
CREATE TABLE units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    symbol VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. Time Units
CREATE TABLE time_units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(20) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. Current Status
CREATE TABLE current_status (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. KEFA Assignments
CREATE TABLE kefa_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 13. Users (Processors)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255),
    role VARCHAR(50),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 14. Development Types
CREATE TABLE development_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- MAIN TABLE (1 table)
-- =============================================

-- 15. Tools (Main Table)
CREATE TABLE tools (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Basic Information
    tool_number VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    tool_type_id UUID,
    publication_status_id UUID,
    vehicle_type_id UUID,
    component_group_id UUID,
    application TEXT,
    tool_category_id UUID,
    order_number VARCHAR(100),
    supplier_id UUID,
    
    -- Dimensions
    length_mm DECIMAL(10,2),
    width_mm DECIMAL(10,2),
    height_mm DECIMAL(10,2),
    main_material VARCHAR(255),
    volume_mm3 DECIMAL(15,2) GENERATED ALWAYS AS (length_mm * width_mm * height_mm) STORED,
    
    -- Risk and Compliance
    gu_relevance BOOLEAN DEFAULT FALSE,
    risk_level_id UUID,
    
    -- Specifications
    specification_needed VARCHAR(20), -- 'yes', 'no', 'evident'
    technical_specification_id UUID,
    specification_min DECIMAL(10,4),
    specification_max DECIMAL(10,4),
    unit_id UUID,
    remark TEXT,
    
    -- Calibration
    calibration_needed BOOLEAN DEFAULT FALSE,
    calibration_interval INTEGER,
    time_unit_id UUID,
    
    -- Status
    current_status_id UUID,
    target_status TEXT, -- Auto-calculated from Prisma data
    co_users TEXT,
    country_variants TEXT,
    plms_requirement_number VARCHAR(100),
    plms_requirement_date DATE,
    required_quantity INTEGER,
    kefa_assignment_id UUID,
    assigned_user_id UUID,
    successor_reference UUID,
    
    -- Development Section
    contact_development_service TEXT,
    contact_product_influencer TEXT,
    contact_developer TEXT,
    apos_number VARCHAR(100),
    manual_available BOOLEAN DEFAULT FALSE,
    risk_analysis_available BOOLEAN DEFAULT FALSE,
    technical_drawing_available BOOLEAN DEFAULT FALSE,
    development_type_id UUID,
    prototype_available BOOLEAN DEFAULT FALSE,
    prototype_target_date DATE,
    budget_forecast_euro DECIMAL(12,2),
    
    -- Series Section
    initial_sample_available BOOLEAN DEFAULT FALSE,
    initial_sample_target_date DATE,
    initial_sample_test_ok BOOLEAN DEFAULT FALSE,
    series_price_euro DECIMAL(12,2),
    planned_goods_receipt DATE,
    series_failure_sample_stored BOOLEAN DEFAULT FALSE,
    sold_units INTEGER DEFAULT 0, -- From SAP PT1
    stock_sachsenheim INTEGER DEFAULT 0, -- From SAP PT1
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    FOREIGN KEY (tool_type_id) REFERENCES tool_types(id),
    FOREIGN KEY (publication_status_id) REFERENCES publication_status(id),
    FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id),
    FOREIGN KEY (component_group_id) REFERENCES component_groups(id),
    FOREIGN KEY (tool_category_id) REFERENCES tool_categories(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    FOREIGN KEY (risk_level_id) REFERENCES risk_levels(id),
    FOREIGN KEY (technical_specification_id) REFERENCES technical_specifications(id),
    FOREIGN KEY (unit_id) REFERENCES units(id),
    FOREIGN KEY (time_unit_id) REFERENCES time_units(id),
    FOREIGN KEY (current_status_id) REFERENCES current_status(id),
    FOREIGN KEY (kefa_assignment_id) REFERENCES kefa_assignments(id),
    FOREIGN KEY (assigned_user_id) REFERENCES users(id),
    FOREIGN KEY (development_type_id) REFERENCES development_types(id),
    FOREIGN KEY (successor_reference) REFERENCES tools(id)
);

-- =============================================
-- TABLES THAT DEPEND ON TOOLS (4 tables)
-- =============================================

-- 16. Product Conformity
CREATE TABLE product_conformity (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tool_id UUID,
    conformity_type VARCHAR(100) NOT NULL,
    file_path VARCHAR(500),
    file_name VARCHAR(255),
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tool_id) REFERENCES tools(id) ON DELETE CASCADE
);

-- 17. Product Images
CREATE TABLE product_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tool_id UUID,
    file_path VARCHAR(500) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_type VARCHAR(10) NOT NULL,
    is_catalog_image BOOLEAN DEFAULT FALSE,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tool_id) REFERENCES tools(id) ON DELETE CASCADE
);

-- 18. Development Files
CREATE TABLE development_files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tool_id UUID,
    file_type VARCHAR(50) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    description TEXT,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tool_id) REFERENCES tools(id) ON DELETE CASCADE
);

-- 19. Development Loops
CREATE TABLE development_loops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tool_id UUID,
    loop_number INTEGER NOT NULL,
    commissioning_file VARCHAR(500),
    test_images TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tool_id) REFERENCES tools(id) ON DELETE CASCADE
);

-- =============================================
-- TRIGGERS FOR UPDATED_AT
-- =============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_tools_updated_at BEFORE UPDATE ON tools
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- INITIAL DATA POPULATION
-- =============================================

-- Tool Types
INSERT INTO tool_types (name) VALUES 
('Accessories'),
('Spare Parts'),
('Commercial Tools'),
('Porsche Special Tools'),
('VW Special Tools'),
('General Workshop Equipment'),
('Vehicle-specific Workshop Equipment');

-- Publication Status
INSERT INTO publication_status (name) VALUES 
('Development'),
('Approval'),
('Publication'),
('No longer available'),
('Standby');

-- Component Groups
INSERT INTO component_groups (code, name) VALUES 
('0', 'Complete Vehicle'),
('1', 'Engine'),
('2', 'Fuel, Exhaust, Engine Electronics'),
('3', 'Power Transmission'),
('4', 'Chassis'),
('5', 'Body'),
('6', 'Body Equipment Exterior'),
('7', 'Body Equipment Interior'),
('8', 'Air Conditioning'),
('9', 'Electrical');

-- Tool Categories
INSERT INTO tool_categories (code, name) VALUES 
('', 'Standard'),
('***', 'Special'),
('****', 'Critical'),
('HV', 'High Voltage'),
('BP', 'Body Parts'),
('CLA', 'Classification A');

-- Risk Levels
INSERT INTO risk_levels (level, color) VALUES 
('green', 'Green'),
('yellow', 'Yellow'),
('red', 'Red');

-- Technical Specifications
INSERT INTO technical_specifications (name) VALUES 
('Torque'),
('Pressure'),
('Force (Tensile/Compressive Force)'),
('Media Resistance'),
('Voltage'),
('Current'),
('Temperature'),
('Load Capacity'),
('Resistance');

-- Units
INSERT INTO units (symbol, name, type) VALUES 
('Nm', 'Newton Meter', 'Torque'),
('N', 'Newton', 'Force'),
('bar', 'Bar', 'Pressure'),
('kg', 'Kilogram', 'Mass'),
('V', 'Volt', 'Voltage'),
('A', 'Ampere', 'Current'),
('°C', 'Celsius', 'Temperature'),
('Ohm', 'Ohm', 'Resistance');

-- Time Units
INSERT INTO time_units (name) VALUES 
('Months'),
('Years');

-- Current Status
INSERT INTO current_status (name, sort_order) VALUES 
('WA initiated (Start)', 1),
('WA constructed', 2),
('Function sample ordered', 3),
('Function sample available', 4),
('Function sample tested', 5),
('WA defined, tested & approved', 6),
('Quotes requested', 7),
('Supplier delivery call made', 8),
('Circular created', 9),
('Circular translated', 10),
('WA available for markets', 11);

-- KEFA Assignments
INSERT INTO kefa_assignments (name) VALUES 
('Electrical'),
('Chassis'),
('Body'),
('Drive');

-- Users
INSERT INTO users (name) VALUES 
('Andreas'),
('Benno'),
('Daniel'),
('Lee'),
('Rainer');

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

CREATE INDEX idx_tools_tool_number ON tools(tool_number);
CREATE INDEX idx_tools_name ON tools(name);
CREATE INDEX idx_tools_tool_type ON tools(tool_type_id);
CREATE INDEX idx_tools_status ON tools(current_status_id);
CREATE INDEX idx_tools_supplier ON tools(supplier_id);
CREATE INDEX idx_tools_assigned_user ON tools(assigned_user_id);
CREATE INDEX idx_product_images_tool_id ON product_images(tool_id);
CREATE INDEX idx_development_files_tool_id ON development_files(tool_id);
CREATE INDEX idx_development_loops_tool_id ON development_loops(tool_id);

-- =============================================
-- VIEWS FOR COMMON QUERIES
-- =============================================

-- Complete tool information view
CREATE VIEW v_tools_complete AS
SELECT 
    t.*,
    tt.name as tool_type_name,
    ps.name as publication_status_name,
    vt.order_type as vehicle_type,
    cg.name as component_group_name,
    tc.name as tool_category_name,
    s.name as supplier_name,
    rl.level as risk_level,
    ts.name as technical_specification_name,
    u.symbol as unit_symbol,
    tu.name as time_unit_name,
    cs.name as current_status_name,
    ka.name as kefa_assignment_name,
    usr.name as assigned_user_name,
    dt.name as development_type_name
FROM tools t
LEFT JOIN tool_types tt ON t.tool_type_id = tt.id
LEFT JOIN publication_status ps ON t.publication_status_id = ps.id
LEFT JOIN vehicle_types vt ON t.vehicle_type_id = vt.id
LEFT JOIN component_groups cg ON t.component_group_id = cg.id
LEFT JOIN tool_categories tc ON t.tool_category_id = tc.id
LEFT JOIN suppliers s ON t.supplier_id = s.id
LEFT JOIN risk_levels rl ON t.risk_level_id = rl.id
LEFT JOIN technical_specifications ts ON t.technical_specification_id = ts.id
LEFT JOIN units u ON t.unit_id = u.id
LEFT JOIN time_units tu ON t.time_unit_id = tu.id
LEFT JOIN current_status cs ON t.current_status_id = cs.id
LEFT JOIN kefa_assignments ka ON t.kefa_assignment_id = ka.id
LEFT JOIN users usr ON t.assigned_user_id = usr.id
LEFT JOIN development_types dt ON t.development_type_id = dt.id;

-- Tools with images count
CREATE VIEW v_tools_with_images AS
SELECT 
    t.id,
    t.tool_number,
    t.name,
    COUNT(pi.id) as image_count,
    COUNT(CASE WHEN pi.is_catalog_image THEN 1 END) as catalog_image_count
FROM tools t
LEFT JOIN product_images pi ON t.id = pi.tool_id
GROUP BY t.id, t.tool_number, t.name;

-- =============================================
-- COMMENTS
-- =============================================

COMMENT ON TABLE tools IS 'Main table containing all tool information';
COMMENT ON COLUMN tools.volume_mm3 IS 'Automatically calculated from length * width * height';
COMMENT ON COLUMN tools.sold_units IS 'Data from SAP PT1 interface';
COMMENT ON COLUMN tools.stock_sachsenheim IS 'Stock data from SAP PT1 interface';
COMMENT ON TABLE vehicle_types IS 'Vehicle data from Prisma vehicle database';
COMMENT ON TABLE product_conformity IS 'CE conformity, ElektroG, RoHS documentation';
COMMENT ON TABLE development_files IS 'Stores 3D data (.step), documentation (.pdf, .xlsm)';