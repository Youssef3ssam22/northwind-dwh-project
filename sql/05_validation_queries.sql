-- ============================================================
-- Analytical validation queries, run after the pipeline
-- completes, to confirm the warehouse works end-to-end.
-- ============================================================

-- Top 5 customers by total spend
SELECT
    cd.company_name,
    ROUND(SUM(sf.total_price)::numeric, 2) AS total_spent
FROM sales_fact sf
JOIN customer_dim cd ON sf.cust_sk = cd.cust_sk
GROUP BY cd.company_name
ORDER BY total_spent DESC
LIMIT 5;

-- Top 5 products by quantity sold
SELECT
    pd.product_name,
    pd.category_name,
    SUM(sf.quantity) AS total_qty_sold
FROM sales_fact sf
JOIN product_dim pd ON sf.product_sk = pd.product_sk
GROUP BY pd.product_name, pd.category_name
ORDER BY total_qty_sold DESC
LIMIT 5;

-- Employee performance (total sales)
SELECT
    ed.full_name,
    ROUND(SUM(sf.total_price)::numeric, 2) AS total_sales
FROM sales_fact sf
JOIN employee_dim ed ON sf.emp_sk = ed.emp_sk
GROUP BY ed.full_name
ORDER BY total_sales DESC;

-- Sales by year/quarter
SELECT
    dd.year,
    dd.quarter,
    ROUND(SUM(sf.total_price)::numeric, 2) AS total_sales
FROM sales_fact sf
JOIN date_dim dd ON sf.order_date_sk = dd.date_sk
GROUP BY dd.year, dd.quarter
ORDER BY dd.year, dd.quarter;

-- Average freight cost by shipping company
SELECT
    sd.company_name,
    COUNT(*) AS num_orders,
    ROUND(AVG(of.freight)::numeric, 2) AS avg_freight
FROM order_fact of
JOIN shipper_dim sd ON of.shipper_sk = sd.shipper_sk
GROUP BY sd.company_name
ORDER BY avg_freight DESC;
