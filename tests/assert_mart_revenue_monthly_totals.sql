select
    SalesMonth
from {{ ref('mart_revenue') }}
group by SalesMonth
having
    abs(sum(category_revenue) - max(monthly_revenue)) > 0.0001
    or min(monthly_revenue) <> max(monthly_revenue)
    or abs(sum(category_quantity) - max(monthly_quantity)) > 0.0001
    or min(monthly_quantity) <> max(monthly_quantity)
    or sum(category_transactions) <> max(monthly_transactions)
    or min(monthly_transactions) <> max(monthly_transactions)
