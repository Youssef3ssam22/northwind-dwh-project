-- ============================================================
-- Northwind DWH - Star Schema DDL
-- Run against the northwind_dwh database (destination).
-- ============================================================

CREATE TABLE customer_dim (
    cust_sk SERIAL PRIMARY KEY,
    customer_id CHAR(5) NOT NULL,
    company_name VARCHAR(100),
    contact_name VARCHAR(100),
    city VARCHAR(50),
    region VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE employee_dim (
    emp_sk SERIAL PRIMARY KEY,
    employee_id SMALLINT NOT NULL,
    full_name VARCHAR(100),
    title VARCHAR(50),
    reports_to INT REFERENCES employee_dim(emp_sk)
);

CREATE TABLE product_dim (
    product_sk SERIAL PRIMARY KEY,
    product_id SMALLINT NOT NULL,
    product_name VARCHAR(100),
    category_name VARCHAR(50),
    supplier_name VARCHAR(100),
    discontinued BOOLEAN
);

CREATE TABLE date_dim (
    date_sk SERIAL PRIMARY KEY,
    actual_date DATE NOT NULL UNIQUE,
    year SMALLINT,
    quarter SMALLINT,
    month SMALLINT,
    day_of_week VARCHAR(10)
);

CREATE TABLE shipper_dim (
    shipper_sk SERIAL PRIMARY KEY,
    shipper_id SMALLINT NOT NULL,
    company_name VARCHAR(100)
);

-- Grain: one row per product per order
CREATE TABLE sales_fact (
    sales_fact_sk SERIAL PRIMARY KEY,
    order_id SMALLINT NOT NULL,
    product_sk INT REFERENCES product_dim(product_sk),
    cust_sk INT REFERENCES customer_dim(cust_sk),
    emp_sk INT REFERENCES employee_dim(emp_sk),
    order_date_sk INT REFERENCES date_dim(date_sk),
    quantity SMALLINT,
    unit_price NUMERIC(10,2),
    discount NUMERIC(4,2),
    total_price NUMERIC(12,2)
);

-- Grain: one row per order. Freight kept separate from sales_fact
-- to avoid additive errors (freight is order-level, not product-level).
CREATE TABLE order_fact (
    order_id SMALLINT PRIMARY KEY,
    cust_sk INT REFERENCES customer_dim(cust_sk),
    shipper_sk INT REFERENCES shipper_dim(shipper_sk),
    order_date_sk INT REFERENCES date_dim(date_sk),
    required_date_sk INT REFERENCES date_dim(date_sk),
    shipped_date_sk INT REFERENCES date_dim(date_sk),
    freight NUMERIC(10,2)
);
