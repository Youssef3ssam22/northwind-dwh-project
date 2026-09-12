-- ============================================================
-- Populate the fact tables. Run after 03_populate_dimensions.sql,
-- since these joins depend on all dimensions already existing.
-- ============================================================

-- sales_fact (expect 2155 rows - one per order_details row, no data loss)
INSERT INTO sales_fact (order_id, product_sk, cust_sk, emp_sk, order_date_sk, quantity, unit_price, discount, total_price)
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
FROM source_data.order_details od
JOIN source_data.orders o ON od.order_id = o.order_id
JOIN product_dim pd ON od.product_id = pd.product_id
JOIN customer_dim cd ON o.customer_id = cd.customer_id
JOIN employee_dim ed ON o.employee_id = ed.employee_id
JOIN date_dim dd ON o.order_date = dd.actual_date;

-- order_fact (expect 830 rows, 21 with NULL shipped_date_sk -
-- LEFT JOINs used since some orders aren't shipped yet)
INSERT INTO order_fact (order_id, cust_sk, shipper_sk, order_date_sk, required_date_sk, shipped_date_sk, freight)
SELECT
    o.order_id,
    cd.cust_sk,
    sd.shipper_sk,
    dd_order.date_sk AS order_date_sk,
    dd_required.date_sk AS required_date_sk,
    dd_shipped.date_sk AS shipped_date_sk,
    o.freight
FROM source_data.orders o
JOIN customer_dim cd ON o.customer_id = cd.customer_id
LEFT JOIN shipper_dim sd ON o.ship_via = sd.shipper_id
LEFT JOIN date_dim dd_order ON o.order_date = dd_order.actual_date
LEFT JOIN date_dim dd_required ON o.required_date = dd_required.actual_date
LEFT JOIN date_dim dd_shipped ON o.shipped_date = dd_shipped.actual_date;
