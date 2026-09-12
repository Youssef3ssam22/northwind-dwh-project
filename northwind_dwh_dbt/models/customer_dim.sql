SELECT 
    ROW_NUMBER() OVER (ORDER BY customer_id) AS cust_sk,
    customer_id,
    company_name,
    contact_name,
    city,
    region,
    country
FROM {{ source('northwind_source', 'customers') }}