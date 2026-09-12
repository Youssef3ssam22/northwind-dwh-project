# Star Schema — Entity Relationship Diagram

Designed after data profiling confirmed the source data was clean. Grain: `sales_fact` = one row per product per order; `order_fact` = one row per order (freight kept separate to avoid additive errors when aggregating).

```mermaid
erDiagram
  CUSTOMER_DIM ||--o{ SALES_FACT : places
  EMPLOYEE_DIM ||--o{ SALES_FACT : records
  PRODUCT_DIM ||--o{ SALES_FACT : contains
  DATE_DIM ||--o{ SALES_FACT : occurs_on
  CUSTOMER_DIM ||--o{ ORDER_FACT : places
  SHIPPER_DIM ||--o{ ORDER_FACT : ships
  DATE_DIM ||--o{ ORDER_FACT : order_date
  DATE_DIM ||--o{ ORDER_FACT : required_date
  DATE_DIM ||--o{ ORDER_FACT : shipped_date

  CUSTOMER_DIM {
    int cust_sk PK
    string customer_id
    string company_name
    string contact_name
    string city
    string region
    string country
  }
  EMPLOYEE_DIM {
    int emp_sk PK
    int employee_id
    string full_name
    string title
    int reports_to
  }
  PRODUCT_DIM {
    int product_sk PK
    int product_id
    string product_name
    string category_name
    string supplier_name
    boolean discontinued
  }
  DATE_DIM {
    int date_sk PK
    date actual_date
    int year
    int quarter
    int month
    string day_of_week
  }
  SHIPPER_DIM {
    int shipper_sk PK
    int shipper_id
    string company_name
  }
  SALES_FACT {
    int order_id
    int product_sk FK
    int cust_sk FK
    int emp_sk FK
    int order_date_sk FK
    int quantity
    numeric unit_price
    numeric discount
    numeric total_price
  }
  ORDER_FACT {
    int order_id PK
    int cust_sk FK
    int shipper_sk FK
    int order_date_sk FK
    int required_date_sk FK
    int shipped_date_sk FK
    numeric freight
  }
```

## Design decisions

- **`date_dim` is a role-playing dimension**: joined once for `sales_fact.order_date_sk`, and three times (order/required/shipped) for `order_fact`.
- **`product_dim` excludes `unit_price`**: the current catalog price would conflict with the historical transaction price already stored in `sales_fact.unit_price`. Keeping only one avoids ambiguity about which price is "correct."
- **`employee_dim.reports_to` is self-referencing**: points to another row's `emp_sk` in the same table, populated via a self-join after all surrogate keys exist.
