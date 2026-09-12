-- ============================================================
-- Connect northwind_dwh to the northwind source database
-- using postgres_fdw (Foreign Data Wrapper), then expose
-- the source tables under a dedicated schema.
-- Run against northwind_dwh.
-- ============================================================

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER northwind_source
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', port '5432', dbname 'northwind');

CREATE USER MAPPING FOR CURRENT_USER
SERVER northwind_source
OPTIONS (user 'postgres', password 'YOUR_PASSWORD_HERE');

CREATE SCHEMA IF NOT EXISTS source_data;

IMPORT FOREIGN SCHEMA public
FROM SERVER northwind_source
INTO source_data;

-- Sanity check
SELECT COUNT(*) FROM source_data.customers; -- expect 91
