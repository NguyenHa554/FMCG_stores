select
    SalesMonth,
    total_revenue as Revenue,
    total_quantity as Quantity,
    transaction_count as Transactions
from {{ ref('int_sales_monthly') }}
