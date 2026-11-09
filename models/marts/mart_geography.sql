{{ config(materialized='table') }}

select
    CityID,
    CityName,
    CountryID,
    CountryName,
    USRegion,
    total_customers,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_revenue_per_transaction,
    avg_quantity_per_transaction,
    revenue_per_customer,
    transactions_per_customer
from {{ ref('int_geography') }}
