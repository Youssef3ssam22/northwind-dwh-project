SELECT 
    ROW_NUMBER() OVER (ORDER BY d) AS date_sk,
    d::date AS actual_date,
    EXTRACT(YEAR FROM d)::int AS year,
    EXTRACT(QUARTER FROM d)::int AS quarter,
    EXTRACT(MONTH FROM d)::int AS month,
    TRIM(TO_CHAR(d, 'Day')) AS day_of_week
FROM generate_series('1996-01-01'::date, '1998-12-31'::date, '1 day') AS d