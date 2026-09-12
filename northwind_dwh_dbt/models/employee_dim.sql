SELECT 
    ROW_NUMBER() OVER (ORDER BY employee_id) AS emp_sk,
    employee_id,
    first_name || ' ' || last_name AS full_name,
    title,
    reports_to
FROM {{ source('northwind_source', 'employees') }}