-- ============================================================
-- 002_seed_data.sql
-- Apartment Rental Management System
-- Authors: Mohammed Khalaf, David Ulloa
-- Description: Seeds all tables with realistic sample data.
-- ============================================================


-- ========== LOOKUP TABLES ==========

-- Seed Lease_Status with valid state values
INSERT INTO Lease_Status (status_name) VALUES
    ('Active'),
    ('Expired'),
    ('Renewed'),
    ('Terminated');

-- Seed Payment_Status with valid payment values
INSERT INTO Payment_Status (payment_status_name) VALUES
    ('Paid'),
    ('Pending'),
    ('Late'),
    ('Waived'),
    ('Partial');



-- ========== TENANTS ==========


-- Seed 8 tenants with unique emails and realistic contact info
INSERT INTO Tenants (full_name, email, phone_number) VALUES
    ('Barack Obama',   'barack.obama@email.com',  '714-555-0101'),
    ('Aubrey Graham',    'aubrey.grahama@email.com',   '714-555-0102'),
    ('Lebron James',       'lebron.james@email.com',      '949-555-0103'),
    ('David Ulloa',         'david.ulloa@email.com',        '562-555-0104'),
    ('Mohammed Khalaf',      'mohammed.khalaf@email.com',     '714-555-0105'),
    ('Shohei Ohtani',     'shohei.ohtani@email.com',    '949-555-0106'),
    ('Natalie Portman',      'natalie.portman@email.com',     '714-555-0107'),
    ('Margot Robbie',     'margot.robbie@email.com',    '562-555-0108');


-- ========== PROPERTIES ==========


-- Seed 5 properties located in Orange County, CA
INSERT INTO Properties (property_name, property_address, management_details) VALUES
    ('Hub Fullerton',  '2601 E Chapman Ave, Fullerton, CA 92831',       'Managed by Core Campus Management. LLC'),
    ('Alight Fullerton',      '555 N Commonwealth Ave, Fullerton, CA 92831',      'Managed by Scion Community'),
    ('UCE Apartment Homes',     '600 Langsdorf Dr, Fullerton, CA 92831', 'On-site manager: Tom Brady'),
    ('UCA Apartment Homes',        '2404 Nutwood Ave, Fullerton, CA 92831',          'Managed by Apartments Management Consultants, Inc.'),
    ('Montclaire Apartments',           '2970 E Ruby Dr, Fullerton, CA 92831',      'Managed by Fullerton Realty Group');



-- ========== UNITS ==========


-- Seed 10 units spread across properties
INSERT INTO Units (property_id, unit_number, monthly_rent, bedroom_count, occupancy_details) VALUES
    (1, '101', 1850.00, 1, 'Ground floor, patio included'),
    (1, '202', 2100.00, 2, 'Second floor, balcony'),
    (1, '305', 2400.00, 3, 'Top floor, corner unit'),
    (2, 'A1', 1750.00, 1, 'Carport parking included'),
    (2, 'B3', 2050.00, 2, 'Pool view'),
    (3, '10', 1950.00, 2, 'Near laundry facilities'),
    (3, '15', 1600.00, 1, 'Compact unit, utilities included'),
    (4, '201', 2300.00, 2, 'Renovated kitchen'),
    (4, '301', 2700.00, 3, 'Top floor, two parking spaces'),
    (5, '105', 1800.00, 1, 'Street level, quiet building');



-- ========== LEASES ==========


-- Seed 10 leases covering active, expired, and terminated states
-- status_id: 1=Active, 2=Expired, 3=Renewed, 4=Terminated
INSERT INTO Leases (unit_id, status_id, start_date, end_date, security_deposit) VALUES
    (1,  1, '2025-01-01', '2026-01-01', 1850.00),  -- Active lease on unit 101
    (2,  1, '2025-03-01', '2026-03-01', 2100.00),  -- Active lease on unit 202
    (3,  2, '2024-01-01', '2025-01-01', 2400.00),  -- Expired lease on unit 305
    (4,  1, '2025-06-01', '2026-06-01', 1750.00),  -- Active lease on unit A1
    (5,  3, '2024-06-01', '2025-06-01', 2050.00),  -- Renewed lease on unit B3
    (5,  1, '2025-06-01', '2026-06-01', 2050.00),  -- New active lease (renewal) on unit B3
    (6,  4, '2024-02-01', '2025-02-01', 1950.00),  -- Terminated lease on unit 10
    (7,  1, '2025-08-01', '2026-08-01', 1600.00),  -- Active lease on unit 15
    (8,  1, '2025-09-01', '2026-09-01', 2300.00),  -- Active lease on unit 201
    (10, 2, '2024-04-01', '2025-04-01', 1800.00);  -- Expired lease on unit 105



-- ========== LEASE_TENANTS (Junction table) ==========


-- Assign tenants to leases; some leases have multiple tenants (roommates)
INSERT INTO Lease_Tenants (lease_id, tenant_id) VALUES
    (1, 1),  -- Barack Obama on lease 1
    (2, 2),  -- Aubrey Graham on lease 2
    (2, 3),  -- Lebron James also on lease 2 (roommates)
    (3, 4),  -- David Ulloa on expired lease 3
    (4, 5),  -- Mohammed Khalaf on lease 4
    (5, 6),  -- Shohei Ohtani on old renewed lease 5
    (6, 6),  -- Shohei Ohtani on current renewal lease 6
    (7, 7),  -- Natalie Portman on terminated lease 7
    (8, 8),  -- Margot Robbie on lease 8
    (9, 1),  -- Barack Obama also on lease 9 (second unit)
    (10, 4);  -- David Ulloa on expired lease 10


-- ========== PAYMENTS ==========


-- Seed 15 payment records across multiple leases
-- payment_status_id: 1=Paid, 2=Pending, 3=Late, 4=Waived, 5=Partial
INSERT INTO Payments (lease_id, payment_status_id, payment_date, payment_amount) VALUES
    (1, 1, '2025-01-01', 1850.00),  -- Barack lease 1, Jan - Paid
    (1, 1, '2025-02-01', 1850.00),  -- Barack lease 1, Feb - Paid
    (1, 3, '2025-03-08', 1850.00),  -- Barack lease 1, Mar - Late
    (2, 1, '2025-03-01', 2100.00),  -- Aubrey/Lebron lease 2, Mar - Paid
    (2, 1, '2025-04-01', 2100.00),  -- Aubrey/Lebron lease 2, Apr - Paid
    (2, 2, '2025-05-01', 2100.00),  -- Aubrey/Lebron lease 2, May - Pending
    (4, 1, '2025-06-01', 1750.00),  -- Mohammed lease 4, Jun - Paid
    (4, 1, '2025-07-01', 1750.00),  -- Mohammed lease 4, Jul - Paid
    (6, 1, '2025-06-01', 2050.00),  -- Shohei renewal lease 6, Jun - Paid
    (6, 5, '2025-07-01', 1000.00),  -- Shohei renewal lease 6, Jul - Partial
    (8, 1, '2025-08-01', 1600.00),  -- Margot lease 8, Aug - Paid
    (8, 1, '2025-09-01', 1600.00),  -- Margot lease 8, Sep - Paid
    (9, 1, '2025-09-01', 2300.00),  -- Barack lease 9, Sep - Paid
    (9, 3, '2025-10-10', 2300.00),  -- Barack lease 9, Oct - Late
    (3, 1, '2024-06-01', 2400.00);  -- David expired lease 3, Paid


-- ========== MAINTENANCE_REQUESTS ==========


-- Seed 10 maintenance requests covering various units and progress states
INSERT INTO Maintenance_Requests (unit_id, issue_description, request_date, request_progress) VALUES
    (1,  'AC unit not cooling properly',         '2025-02-15', 'Completed'),
    (2,  'Leaking faucet in bathroom',           '2025-04-03', 'In Progress'),
    (3,  'Broken window latch on bedroom',       '2024-11-20', 'Completed'),
    (4,  'Dishwasher not draining',              '2025-07-10', 'Pending'),
    (5,  'Water heater making loud noise',       '2025-05-22', 'Completed'),
    (6,  'Mold found under kitchen sink',        '2025-01-08', 'Completed'),
    (7,  'Smoke detector battery needs replace', '2025-09-01', 'Pending'),
    (8,  'Garbage disposal jammed',              '2025-09-15', 'In Progress'),
    (9,  'Front door lock sticking',             '2025-10-02', 'Pending'),
    (10, 'Ceiling light fixture flickering',     '2024-12-10', 'Completed');
