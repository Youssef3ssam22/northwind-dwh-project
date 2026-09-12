SELECT 
    od.order_id,
    pd.product_sk,
    cd.cust_sk,
    ed.emp_sk,
    dd.date_sk AS order_date_sk,
    od.quantity,
    od.unit_price,
    od.discount,
    ROUND((od.quantity * od.unit_price * (1 - od.discount))::numeric, 2) AS total_price
FROM {{ source('northwind_source', 'order_details') }} od
JOIN {{ source('northwind_source', 'orders') }} o 
    ON od.order_id = o.order_id
JOIN {{ ref('product_dim') }} pd 
    ON od.product_id = pd.product_id
JOIN {{ ref('customer_dim') }} cd 
    ON o.customer_id = cd.customer_id
JOIN {{ ref('employee_dim') }} ed 
    ON o.employee_id = ed.employee_id
JOIN {{ ref('date_dim') }} dd 
    ON o.order_date = dd.actual_date