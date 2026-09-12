SELECT 
    o.order_id,
    cd.cust_sk,
    sd.shipper_sk,
    dd_order.date_sk AS order_date_sk,
    dd_required.date_sk AS required_date_sk,
    dd_shipped.date_sk AS shipped_date_sk,
    o.freight
FROM {{ source('northwind_source', 'orders') }} o
JOIN {{ ref('customer_dim') }} cd 
    ON o.customer_id = cd.customer_id
LEFT JOIN {{ ref('shipper_dim') }} sd 
    ON o.ship_via = sd.shipper_id
LEFT JOIN {{ ref('date_dim') }} dd_order 
    ON o.order_date = dd_order.actual_date
LEFT JOIN {{ ref('date_dim') }} dd_required 
    ON o.required_date = dd_required.actual_date
LEFT JOIN {{ ref('date_dim') }} dd_shipped 
    ON o.shipped_date = dd_shipped.actual_date