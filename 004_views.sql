-- ============================================================
-- 004_views_examples.sql
-- Apartment Rental Management System
-- Authors: Mohammed Khalaf, David Ulloa
-- Description: This migration creates database views to provide simplified 
-- access to key information in the Apartment Rental Management System. 
-- ============================================================


-- ========== VIEWS ==========


-- VIEW 1: Active leases with tenant names, unit info, and property name.
-- Useful for leasing staff to see all currently occupied units at a one time.
CREATE OR REPLACE VIEW vw_active_leases AS
SELECT
    l.lease_id,
    p.property_name,
    u.unit_number,
    u.monthly_rent,
    t.full_name     AS tenant_name,
    t.email         AS tenant_email,
    l.start_date,
    l.end_date,
    ls.status_name  AS lease_status
FROM Leases l
JOIN Units          u  ON l.unit_id   = u.unit_id
JOIN Properties     p  ON u.property_id = p.property_id
JOIN Lease_Status   ls ON l.status_id = ls.status_id
JOIN Lease_Tenants  lt ON l.lease_id  = lt.lease_id
JOIN Tenants        t  ON lt.tenant_id = t.tenant_id
WHERE ls.status_name = 'Active';


-- VIEW 2: Overdue / late payment summary with tenant and unit details.
-- Allows managers to quickly identify accounts requiring follow-up.
CREATE OR REPLACE VIEW vw_late_payments AS
SELECT
    pay.payment_id,
    t.full_name       AS tenant_name,
    t.phone_number,
    p.property_name,
    u.unit_number,
    pay.payment_date,
    pay.payment_amount,
    ps.payment_status_name AS payment_status
FROM Payments pay
JOIN Payment_Status  ps ON pay.payment_status_id = ps.payment_status_id
JOIN Leases          l  ON pay.lease_id           = l.lease_id
JOIN Units           u  ON l.unit_id              = u.unit_id
JOIN Properties      p  ON u.property_id          = p.property_id
JOIN Lease_Tenants   lt ON l.lease_id             = lt.lease_id
JOIN Tenants         t  ON lt.tenant_id           = t.tenant_id
WHERE ps.payment_status_name IN ('Late', 'Partial', 'Pending');


-- VIEW 3: Open maintenance requests per property.
-- Maintenance staff can filter to their assigned property.
CREATE OR REPLACE VIEW vw_open_maintenance AS
SELECT
    mr.request_id,
    p.property_name,
    u.unit_number,
    mr.issue_description,
    mr.request_date,
    mr.request_progress
FROM Maintenance_Requests mr
JOIN Units      u ON mr.unit_id     = u.unit_id
JOIN Properties p ON u.property_id = p.property_id
WHERE mr.request_progress IN ('Pending', 'In Progress')
ORDER BY mr.request_date ASC;

