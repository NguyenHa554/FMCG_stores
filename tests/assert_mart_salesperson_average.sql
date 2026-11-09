select
    mart_salesperson_id
from {{ ref('mart_salesperson') }}
where abs(
    avg_revenue_per_transaction
    - total_revenue / nullif(total_transactions, 0)
) > 0.0001
