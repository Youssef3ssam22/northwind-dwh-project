-- ============================================================
-- Populate all dimension tables from the source_data schema.
-- Run against northwind_dwh, after 01 and 02.
-- ============================================================

-- customer_dim (expect 91 rows)
INSERT INTO customer_dim (customer_id, company_name, contact_name, city, region, country)
SELECT
    customer_id,
    company_name,
    contact_name,
    city,
    region,
    country
FROM source_data.customers;

-- employee_dim (expect 9 rows). reports_to left NULL here;
-- fixed up below once all surrogate keys exist.
INSERT INTO employee_dim (employee_id, full_name, title)
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    title
FROM source_data.employees;

-- Map employee_id -> emp_sk for the self-referencing hierarchy
UPDATE employee_dim ed
SET reports_to = mgr.emp_sk
FROM source_data.employees e
JOIN employee_dim mgr ON mgr.employee_id = e.reports_to
WHERE ed.employee_id = e.employee_id
  AND e.reports_to IS NOT NULL;

-- product_dim (expect 77 rows) - flattens category & supplier names
INSERT INTO product_dim (product_id, product_name, category_name, supplier_name, discontinued)
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    s.company_name AS supplier_name,
    CASE WHEN p.discontinued = 1 THEN TRUE ELSE FALSE END AS discontinued
FROM source_data.products p
LEFT JOIN source_data.categories c ON p.category_id = c.category_id
LEFT JOIN source_data.suppliers s ON p.supplier_id = s.supplier_id;

-- shipper_dim (expect 6 rows)
INSERT INTO shipper_dim (shipper_id, company_name)
SELECT shipper_id, company_name
FROM source_data.shippers;

-- date_dim (expect 1095 rows) - generated, not sourced from Northwind
-- (Northwind has no native calendar table)
INSERT INTO date_dim (actual_date, year, quarter, month, day_of_week)
SELECT
    d::date AS actual_date,
    EXTRACT(YEAR FROM d) AS year,
    EXTRACT(QUARTER FROM d) AS quarter,
    EXTRACT(MONTH FROM d) AS month,
    TRIM(TO_CHAR(d, 'Day')) AS day_of_week
FROM generate_series('1996-01-01'::date, '1998-12-31'::date, '1 day') AS d;
