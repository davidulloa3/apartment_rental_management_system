-- ============================================================
-- 005_queries_examples.sql
-- Apartment Rental Management System
-- Authors: Mohammed Khalaf, David Ulloa
-- Description: This migration provides example SQL queries for reading 
-- and updating data in the Apartment Rental Management System. 
-- ============================================================


-- ========== READ (SELECT) QUERIES ==========


-- READ 1: Show all active leases using the vw_active_leases view.
-- Quick summary for leasing staff of current occupants.
SELECT * FROM vw_active_leases;


-- READ 2: List all tenants with their current active lease and unit info.
-- Joins Tenants -> Lease_Tenants -> Leases -> Units -> Properties.
SELECT
    t.tenant_id,
    t.full_name,
    t.email,
    p.property_name,
    u.unit_number,
    l.start_date,
    l.end_date
FROM Tenants t
JOIN Lease_Tenants  lt ON t.tenant_id  = lt.tenant_id
JOIN Leases         l  ON lt.lease_id  = l.lease_id
JOIN Lease_Status   ls ON l.status_id  = ls.status_id
JOIN Units          u  ON l.unit_id    = u.unit_id
JOIN Properties     p  ON u.property_id = p.property_id
WHERE ls.status_name = 'Active'
ORDER BY t.full_name;


-- READ 3: Show all overdue payments with tenant name and unit number.
-- Uses the vw_late_payments view to surface accounts needing contact.
SELECT * FROM vw_late_payments;


-- READ 4: Count total payments collected per property.
-- Useful for revenue reporting.
SELECT
    p.property_name,
    COUNT(pay.payment_id)    AS total_payments,
    SUM(pay.payment_amount)  AS total_collected
FROM Payments pay
JOIN Payment_Status ps ON pay.payment_status_id = ps.payment_status_id
JOIN Leases         l  ON pay.lease_id           = l.lease_id
JOIN Units          u  ON l.unit_id              = u.unit_id
JOIN Properties     p  ON u.property_id          = p.property_id
WHERE ps.payment_status_name = 'Paid'
GROUP BY p.property_name
ORDER BY total_collected DESC;


-- READ 5: Show all open maintenance requests using the vw_open_maintenance view.
-- Maintenance staff uses this daily to prioritize work orders.
SELECT * FROM vw_open_maintenance;


-- READ 6: List units with no current active lease (vacant units).
-- Helps leasing staff identify units available for new tenants.
SELECT
    p.property_name,
    u.unit_id,
    u.unit_number,
    u.monthly_rent,
    u.bedroom_count
FROM Units u
JOIN Properties p ON u.property_id = p.property_id
WHERE u.unit_id NOT IN (
    SELECT l.unit_id
    FROM Leases l
    JOIN Lease_Status ls ON l.status_id = ls.status_id
    WHERE ls.status_name = 'Active'
)
ORDER BY p.property_name, u.unit_number;


-- READ 7: List all leases for a specific tenant (full history).
-- Provides a complete rental history for tenant_id = 1 (Barack Obama).
SELECT
    l.lease_id,
    p.property_name,
    u.unit_number,
    l.start_date,
    l.end_date,
    ls.status_name AS lease_status,
    l.security_deposit
FROM Leases l
JOIN Lease_Status   ls ON l.status_id   = ls.status_id
JOIN Units          u  ON l.unit_id     = u.unit_id
JOIN Properties     p  ON u.property_id = p.property_id
JOIN Lease_Tenants  lt ON l.lease_id    = lt.lease_id
WHERE lt.tenant_id = 1
ORDER BY l.start_date DESC;


-- READ 8: Show all payments for a specific lease with status details.
-- Provides the full payment information for lease_id = 2.
SELECT
    pay.payment_id,
    pay.payment_date,
    pay.payment_amount,
    ps.payment_status_name AS status
FROM Payments pay
JOIN Payment_Status ps ON pay.payment_status_id = ps.payment_status_id
WHERE pay.lease_id = 2
ORDER BY pay.payment_date;



-- ========== UPDATE QUERIES ==========


-- UPDATE 1: Mark a lease as Expired once its end date has passed.
-- Keeps lease statuses current after the period ends.
UPDATE Leases
SET status_id = (SELECT status_id FROM Lease_Status WHERE status_name = 'Expired')
WHERE end_date < CURRENT_DATE
  AND status_id = (SELECT status_id FROM Lease_Status WHERE status_name = 'Active');


-- UPDATE 2: Update a tenant's phone number after they report a change.
-- Corrects contact info for tenant_id = 3 (Lebron James).
UPDATE Tenants
SET phone_number = '714-555-0999'
WHERE tenant_id = 3;


-- UPDATE 3: Increase monthly rent by 5% for all units in property_id = 1.
-- Reflects an annual rent adjustment for Hub Fullerton.
UPDATE Units
SET monthly_rent = ROUND(monthly_rent * 1.05, 2)
WHERE property_id = 1;


-- UPDATE 4: Mark a pending payment as Paid after confirmation is received.
-- Updates payment status for payment_id = 6.
UPDATE Payments
SET payment_status_id = (SELECT payment_status_id FROM Payment_Status WHERE payment_status_name = 'Paid')
WHERE payment_id = 6;


-- UPDATE 5: Mark a maintenance request as Completed after the job is done.
-- Updates request_id = 2 (leaking faucet).
UPDATE Maintenance_Requests
SET request_progress = 'Completed'
WHERE request_id = 2;


-- UPDATE 6: Update the management details for a property after manager change.
-- Property_id = 3 (UCE Apartment Homes) has a new on-site manager.
UPDATE Properties
SET management_details = 'On-site manager: Patrick Mahomes'
WHERE property_id = 3;


-- UPDATE 7: Set a lease status to Terminated for a specific lease.
-- Lease_id = 9 ended early by mutual agreement.
UPDATE Leases
SET status_id = (SELECT status_id FROM Lease_Status WHERE status_name = 'Terminated')
WHERE lease_id = 9;



-- ========== DELETE QUERIES ==========


-- DELETE 1: Remove a canceled maintenance request that was submitted in error.
-- Deletes the open pending request for request_id = 9.
DELETE FROM Maintenance_Requests
WHERE request_id = 9
  AND request_progress = 'Pending';


-- DELETE 2: Remove a tenant record who has no lease history.
-- Safe to delete only if tenant is not referenced in Lease_Tenants.
-- (Creates a temporary test tenant first, then deletes it.)
INSERT INTO Tenants (full_name, email, phone_number)
    VALUES ('Test User Temp', 'temp.user@email.com', '000-000-0000');

DELETE FROM Tenants
WHERE email = 'temp.user@email.com';


-- DELETE 3: Remove all waived payments from the system for cleanup.
-- Waived entries are no longer needed in the payment history.
DELETE FROM Payments
WHERE payment_status_id = (
    SELECT payment_status_id FROM Payment_Status WHERE payment_status_name = 'Waived'
);


-- DELETE 4: Remove a tenant from a specific lease (such as roommate moved out).
-- Removes Lebron James (tenant_id = 3) from lease_id = 2.
DELETE FROM Lease_Tenants
WHERE lease_id  = 2
  AND tenant_id = 3;


-- DELETE 5: Remove all maintenance requests for a unit that no longer exists.
-- Cleans up orphaned records before deleting the unit itself.
-- (Creates a temporary unit and request for demonstration.)
INSERT INTO Units (property_id, unit_number, monthly_rent, bedroom_count)
    VALUES (5, '999', 100.00, 0);

INSERT INTO Maintenance_Requests (unit_id, issue_description, request_date)
    VALUES (
        (SELECT unit_id FROM Units WHERE unit_number = '999' AND property_id = 5),
        'Test request for temp unit',
        CURRENT_DATE
    );

DELETE FROM Maintenance_Requests
WHERE unit_id = (SELECT unit_id FROM Units WHERE unit_number = '999' AND property_id = 5);

DELETE FROM Units
WHERE unit_number = '999' AND property_id = 5;


-- DELETE 6: Remove an expired lease that has no associated payments.
-- Cleans up records where the lease ended without any transactions.
DELETE FROM Leases
WHERE status_id = (SELECT status_id FROM Lease_Status WHERE status_name = 'Expired')
  AND lease_id NOT IN (SELECT DISTINCT lease_id FROM Payments)
  AND lease_id NOT IN (SELECT DISTINCT lease_id FROM Lease_Tenants);


-- DELETE 7: Remove all maintenance requests that have been completed
-- and are older than one year, for cleanup purposes.
DELETE FROM Maintenance_Requests
WHERE request_progress = 'Completed'
  AND request_date < CURRENT_DATE - INTERVAL '1 year';
