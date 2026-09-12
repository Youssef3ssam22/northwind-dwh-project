SELECT 
    ROW_NUMBER() OVER (ORDER BY shipper_id) AS shipper_sk,
    shipper_id,
    company_name
FROM {{ source('northwind_source', 'shippers') }}