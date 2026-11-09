{{ config(materialized='table') }}

select
    mart_salesperson_id,
    SalesMonth,
    SalesPersonID,
    SalesPersonName,
    Gender,
    HireDate,
    total_transactions,
    total_quantity,
    total_revenue,
    avg_revenue_per_transaction
from {{ ref('int_salesperson') }}
