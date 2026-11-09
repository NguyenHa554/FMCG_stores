{{ config(materialized='table') }}

select
    CustomerID,
    CustomerName,
    CityID,
    CityName,
    CountryID,
    CountryName,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_quantity_per_transaction,
    avg_order_value,
    first_purchase_date,
    last_purchase_date,
    customer_type,
    customer_segment
from {{ ref('int_customer') }}
