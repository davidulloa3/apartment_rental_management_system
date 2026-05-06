-- ============================================================
-- 003_triggers_examples.sql
-- Apartment Rental Management System
-- Authors: Mohammed Khalaf, David Ulloa
-- Description: This migration adds database triggers to enforce 
-- business rules in the Apartment Rental Management System. 
-- ============================================================

-- ========== TRIGGERS ==========


-- TRIGGER 1: Prevent overlapping active leases on the same unit.
-- Before inserting a new lease, checks if the unit already has
-- an active lease preventing overlapping.
CREATE OR REPLACE FUNCTION prevent_overlapping_active_lease()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Leases l
        JOIN Lease_Status ls ON l.status_id = ls.status_id
        WHERE l.unit_id = NEW.unit_id
          AND ls.status_name = 'Active'
          AND l.start_date < NEW.end_date
          AND l.end_date   > NEW.start_date
    ) THEN
        RAISE EXCEPTION 'Unit % already has an active lease for the given date range.', NEW.unit_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_no_overlapping_active_lease
BEFORE INSERT ON Leases
FOR EACH ROW
EXECUTE FUNCTION prevent_overlapping_active_lease();


-- TRIGGER 2: Automatically set request_progress to 'Pending' if null
-- when a new maintenance request is inserted.
CREATE OR REPLACE FUNCTION set_default_maintenance_progress()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.request_progress IS NULL OR NEW.request_progress = '' THEN
        NEW.request_progress := 'Pending';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_default_maintenance_progress
BEFORE INSERT ON Maintenance_Requests
FOR EACH ROW
EXECUTE FUNCTION set_default_maintenance_progress();

