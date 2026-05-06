None selected

Skip to content
Using Gmail with screen readers
1 of 390
README
Inbox

David Ulloa <davidmontesinosulloa@gmail.com>
Attachments
11:55 AM (0 minutes ago)
to me

 One attachment
  •  Scanned by Gmail
# Apartment Rental Management System

## Project Overview

The **Apartment Rental Management System** is a PostgreSQL database project designed to manage apartment rental operations. The system stores and organizes information about tenants, rental properties, units, leases, rent payments, and maintenance requests.

This project demonstrates how a relational database can support common property management tasks, including:

- Tracking active and inactive leases
- Managing tenant and property information
- Recording rent payments
- Identifying late, pending, or partial payments
- Tracking open maintenance requests
- Reporting rental activity by property and unit

The database uses normalized relational tables, primary keys, foreign keys, constraints, indexes, triggers, and views to maintain data integrity and support useful queries.

---

## Authors

- Mohammed Khalaf
- David Ulloa

---

## Technologies Used

- PostgreSQL
- SQL
- PL/pgSQL
- Supabase
- dbdiagram.io

---

## Database Design

The database is designed around the following main entities:

- `Lease_Status`
- `Payment_Status`
- `Tenants`
- `Properties`
- `Units`
- `Leases`
- `Payments`
- `Maintenance_Requests`
- `Lease_Tenants`

The design supports one-to-many relationships such as:

- One property can have many units.
- One unit can have many leases over time.
- One lease can have many payments.
- One unit can have many maintenance requests.
- One lease status can apply to many leases.
- One payment status can apply to many payments.

The database also includes a many-to-many relationship between leases and tenants through the `Lease_Tenants` junction table. This allows multiple tenants to be connected to the same lease, such as roommates sharing an apartment.

---

## Entity Relationship Diagram

The following ERD was created using dbdiagram.io. It shows the structure of the Apartment Rental Management System database, including the main tables, primary keys, foreign keys, and relationships between entities.

![Apartment Rental Management System ERD](Apartment%20Rental%20Management%20System.png)

If the image does not display, the ERD can also be viewed as a PDF:

[View the Apartment Rental Management System ERD PDF](Apartment%20Rental%20Management%20System.pdf)

---

## Project Files

This project includes the following files:

```text
README.md
001_init.sql
002_seed_data.sql
003_triggers.sql
004_views.sql
005_queries_examples.sql
Apartment Rental Management System.pdf
Apartment Rental Management System.png
```

### File Descriptions

| File | Description |
|---|---|
| `001_init.sql` | Creates the database schema, including tables, primary keys, foreign keys, constraints, and indexes. |
| `002_seed_data.sql` | Inserts sample data into the database for testing and demonstration. |
| `003_triggers.sql` | Creates trigger functions and triggers to enforce database business rules. |
| `004_views.sql` | Creates views for common reports, such as active leases, late payments, and open maintenance requests. |
| `005_queries_examples.sql` | Contains example SELECT, UPDATE, and DELETE queries to demonstrate database functionality. |
| `Apartment Rental Management System.pdf` | Contains the dbdiagram.io ERD/database diagram as a PDF. |
| `Apartment Rental Management System.png` | Contains the dbdiagram.io ERD/database diagram as an embedded README image. |

---

## Database Tables

### `Lease_Status`

Stores valid lease status values, such as active, expired, terminated, or pending.

### `Payment_Status`

Stores valid payment status values, such as paid, pending, late, partial, or waived.

### `Tenants`

Stores tenant contact information, including full name, email, and phone number.

### `Properties`

Stores information about rental properties, including property name, address, and management details.

### `Units`

Stores information about individual rental units, including unit number, monthly rent, bedroom count, and occupancy details.

### `Leases`

Stores lease agreements between tenants and rental units. Each lease includes a start date, end date, security deposit, unit reference, and lease status.

### `Lease_Tenants`

A junction table that connects tenants to leases. This supports multiple tenants on the same lease.

### `Payments`

Stores rent payment records connected to leases. Each payment includes a payment date, payment amount, and payment status.

### `Maintenance_Requests`

Stores maintenance issues for rental units, including the issue description, request date, and progress status.

---

## Key Features

- Relational database schema with primary and foreign key constraints
- Lookup tables for lease and payment statuses
- Many-to-many relationship between tenants and leases
- Seed data for testing and demonstration
- Indexes to improve query performance
- Triggers for enforcing business rules
- Views for commonly needed reports
- Example queries for reading, updating, and deleting data
- Cloud database deployment using Supabase
- ERD created with dbdiagram.io

---

## Triggers

The project includes database triggers to automate and enforce business logic.

### Overlapping Lease Prevention

The database includes a trigger that helps prevent overlapping active leases for the same rental unit.

### Maintenance Progress Default

The database includes a trigger that automatically sets a maintenance request progress value when needed.

---

## Views

The project includes views to simplify common reporting queries.

### `vw_active_leases`

Displays active lease information, including related tenant, unit, and property data.

### `vw_late_payments`

Displays payment records that may require follow-up, such as late, pending, or partial payments.

### `vw_open_maintenance`

Displays maintenance requests that are still open or not completed.

---

## How to Run the Project

The SQL files should be run in the following order:

```text
001_init.sql
002_seed_data.sql
003_triggers.sql
004_views.sql
005_queries_examples.sql
```

### Step 1: Create the Schema

Run:

```text
001_init.sql
```

This creates all database tables, constraints, relationships, and indexes.

### Step 2: Insert Seed Data

Run:

```text
002_seed_data.sql
```

This inserts sample records for tenants, properties, units, leases, payments, and maintenance requests.

### Step 3: Create Triggers

Run:

```text
003_triggers.sql
```

This creates trigger functions and triggers for database logic.

### Step 4: Create Views

Run:

```text
004_views.sql
```

This creates reusable reporting views.

### Step 5: Run Example Queries

Run:

```text
005_queries_examples.sql
```

This demonstrates SELECT, UPDATE, and DELETE operations.

---

## Supabase Migration Instructions

To run this project in Supabase:

1. Open the Supabase project dashboard.
2. Go to **SQL Editor**.
3. Create a new query.
4. Paste the contents of `001_init.sql`.
5. Click **Run**.
6. Repeat the process for each SQL file in order.

Make sure each file runs successfully before moving to the next file.

Important: In Supabase SQL Editor, make sure no text is highlighted unless you intentionally want to run only the selected SQL.

---

## Demo Evidence

For the project demo video, the following evidence should be shown.

### Schema Created

Run a query to show the created tables:

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
```

This proves that the schema was successfully created.

### Data Inserted

Run a query to show row counts:

```sql
SELECT 'lease_status' AS table_name, COUNT(*) AS row_count FROM lease_status
UNION ALL
SELECT 'payment_status', COUNT(*) FROM payment_status
UNION ALL
SELECT 'tenants', COUNT(*) FROM tenants
UNION ALL
SELECT 'properties', COUNT(*) FROM properties
UNION ALL
SELECT 'units', COUNT(*) FROM units
UNION ALL
SELECT 'leases', COUNT(*) FROM leases
UNION ALL
SELECT 'lease_tenants', COUNT(*) FROM lease_tenants
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'maintenance_requests', COUNT(*) FROM maintenance_requests;
```

This proves that sample data was inserted into the database.

### Triggers Created

Run a query to show the created triggers:

```sql
SELECT trigger_name, event_object_table
FROM information_schema.triggers
ORDER BY event_object_table, trigger_name;
```

This confirms that the trigger logic was created successfully.

### Views Created

Run a query to show the created views:

```sql
SELECT viewname
FROM pg_views
WHERE schemaname = 'public'
ORDER BY viewname;
```

This confirms that the reporting views were created successfully.

### Queries Executed With Visible Results

Run example queries such as:

```sql
SELECT * FROM vw_active_leases;
```

```sql
SELECT * FROM vw_late_payments;
```

```sql
SELECT * FROM vw_open_maintenance;
```

These queries demonstrate that the database was created successfully, data was inserted, and useful query results can be returned from the cloud database.

---

## Example Reporting Query

The following query calculates total paid rent collected by property:

```sql
SELECT
    p.property_name,
    COUNT(pay.payment_id) AS total_payments,
    SUM(pay.payment_amount) AS total_collected
FROM payments pay
JOIN payment_status ps ON pay.payment_status_id = ps.payment_status_id
JOIN leases l ON pay.lease_id = l.lease_id
JOIN units u ON l.unit_id = u.unit_id
JOIN properties p ON u.property_id = p.property_id
WHERE ps.payment_status_name = 'Paid'
GROUP BY p.property_name
ORDER BY total_collected DESC;
```

This query demonstrates how the database can join multiple related tables to produce useful reporting results.

---

## Example Use Cases

This database can be used by a property manager to:

- View all active leases
- Check which tenants are assigned to each lease
- Track rent payments by lease or property
- Identify late or incomplete payments
- Find available or vacant units
- Monitor open maintenance requests
- Update tenant contact information
- Mark maintenance requests as completed

---

## Notes

PostgreSQL automatically stores unquoted table names in lowercase. For example, a table created as `Lease_Status` can be queried as `lease_status`.

For consistency, the demo evidence queries use lowercase table names.

If the ERD image does not appear in the README, make sure the image file is uploaded to the same repository folder as `README.md` and that the file name matches exactly:

```text
Apartment Rental Management System.png
```

---

## Conclusion

The Apartment Rental Management System demonstrates a complete relational database design for managing apartment rental information. It includes schema creation, sample data, triggers, views, and example queries. The project shows how PostgreSQL can be used to organize property management data and support practical rental management workflows.
README.md
Displaying README.md.
