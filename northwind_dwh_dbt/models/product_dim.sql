SELECT 
    ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_sk,
    p.product_id,
    p.product_name,
    c.category_name,
    s.company_name AS supplier_name,
    CASE WHEN p.discontinued = 1 THEN TRUE ELSE FALSE END AS discontinued
FROM {{ source('northwind_source', 'products') }} p
LEFT JOIN {{ source('northwind_source', 'categories') }} c 
    ON p.category_id = c.category_id
LEFT JOIN {{ source('northwind_source', 'suppliers') }} s 
    ON p.supplier_id = s.supplier_id