-- ============================================================
-- 001_init.sql
-- Apartment Rental Management System
-- Authors: Mohammed Khalaf, David Ulloa
-- Description: Creates all tables, constraints, and indexes
--              for the Apartment Rental Management System.
-- ============================================================


-- ========== LOOKUP / REFERENCE TABLES ===========

-- These must be created first because core tables reference them.
-- Lease_Status: Stores valid status values for leases.
-- Prevents invalid status strings from being entered directly.

CREATE TABLE Lease_Status (

    -- Auto-incrementing surrogate key
    status_id   SERIAL PRIMARY KEY,      

    -- Makes unique, readable status labels
    status_name VARCHAR(50) NOT NULL UNIQUE 
);




-- Payment_Status: Stores valid status values for payments.

CREATE TABLE Payment_Status (
    payment_status_id   SERIAL PRIMARY KEY,
    payment_status_name VARCHAR(50) NOT NULL UNIQUE
);


-- ========== DATABASE TABLES ===========

-- Tenants: Stores personal information for each renter.
-- Each tenant has a unique email to prevent duplicate accounts.

CREATE TABLE Tenants (
    tenant_id    SERIAL PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,

    -- Tenant emails must be unique
    email        VARCHAR(150) NOT NULL UNIQUE, 

    phone_number VARCHAR(20)
);

-- Properties: Represents a physical rental property (building/complex).
-- Management details stored as free text for multiple notes/contacts.
CREATE TABLE Properties (
    property_id        SERIAL PRIMARY KEY,
    property_name      VARCHAR(150) NOT NULL,
    property_address   VARCHAR(255) NOT NULL,
    management_details TEXT
);

-- Units: Represents individual rentable units in a property.
-- Each unit belongs to exactly one property which is enforced by the foreign key.
CREATE TABLE Units (
    unit_id          SERIAL PRIMARY KEY,
    property_id      INT           NOT NULL,
    unit_number      VARCHAR(20)   NOT NULL,

    -- Rent must be positive
    monthly_rent     DECIMAL(10,2) NOT NULL CHECK (monthly_rent > 0), 


    bedroom_count    INT           NOT NULL CHECK (bedroom_count >= 0),
    occupancy_details TEXT,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,

    -- No duplicate unit numbers at the same property
    UNIQUE (property_id, unit_number)  
);

-- Leases: Connects a unit to a time period and terms.
-- Status is referenced from the Lease_Status lookup table.
CREATE TABLE Leases (
    lease_id         SERIAL PRIMARY KEY,
    unit_id          INT            NOT NULL,
    status_id        INT            NOT NULL,
    start_date       DATE           NOT NULL,
    end_date         DATE           NOT NULL,
    security_deposit DECIMAL(10,2)  NOT NULL CHECK (security_deposit >= 0),
    FOREIGN KEY (unit_id)   REFERENCES Units(unit_id) ON DELETE RESTRICT,
    FOREIGN KEY (status_id) REFERENCES Lease_Status(status_id),

    -- Business rule: lease start date must be before end date
    CONSTRAINT chk_lease_dates CHECK (start_date < end_date)
);

-- Payments: Records individual rent payments tied to a specific lease.
-- Status is referenced from the Payment_Status lookup table.
CREATE TABLE Payments (
    payment_id       SERIAL PRIMARY KEY,
    lease_id         INT            NOT NULL,
    payment_status_id INT           NOT NULL,
    payment_date     DATE           NOT NULL,
    payment_amount   DECIMAL(10,2)  NOT NULL CHECK (payment_amount > 0),
    FOREIGN KEY (lease_id)          REFERENCES Leases(lease_id) ON DELETE RESTRICT,
    FOREIGN KEY (payment_status_id) REFERENCES Payment_Status(payment_status_id)
);

-- Maintenance_Requests: Tracks service requests submitted for a specific unit.
-- Progress is stored as free text to allow for maintenence notes.
CREATE TABLE Maintenance_Requests (
    request_id          SERIAL PRIMARY KEY,
    unit_id             INT          NOT NULL,
    issue_description   TEXT         NOT NULL,
    request_date        DATE         NOT NULL,
    request_progress    VARCHAR(100) DEFAULT 'Pending',
    FOREIGN KEY (unit_id) REFERENCES Units(unit_id) ON DELETE CASCADE
);

-- Lease_Tenants: Junction table resolving the M:M relationship
-- between Tenants and Leases (e.g., roommates on the same lease).
-- Composite PK ensures each tenant-lease pair is unique.
CREATE TABLE Lease_Tenants (
    lease_id  INT NOT NULL,
    tenant_id INT NOT NULL,
    PRIMARY KEY (lease_id, tenant_id),
    FOREIGN KEY (lease_id)  REFERENCES Leases(lease_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES Tenants(tenant_id) ON DELETE CASCADE
);



-- ========== INDEXES ===========
-- Improve query performance on typical queries.

-- Speed up lookups of units by property
CREATE INDEX idx_units_property_id        ON Units(property_id);

-- Speed up lease lookups by unit and status
CREATE INDEX idx_leases_unit_id           ON Leases(unit_id);
CREATE INDEX idx_leases_status_id         ON Leases(status_id);

-- Speed up payment lookups by lease
CREATE INDEX idx_payments_lease_id        ON Payments(lease_id);

-- Speed up maintenance request lookups by unit
CREATE INDEX idx_maintenance_unit_id      ON Maintenance_Requests(unit_id);

-- Speed up junction table lookups in both directions
CREATE INDEX idx_lease_tenants_tenant_id  ON Lease_Tenants(tenant_id);
CREATE INDEX idx_lease_tenants_lease_id   ON Lease_Tenants(lease_id);
