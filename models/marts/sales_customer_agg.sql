select
    CustomerID,
    count(*) as total_transactions,
    sum(Quantity) as total_quantity,
    round(sum(Revenue), 4) as total_revenue,
    round(avg(Quantity), 4) as avg_quantity_per_transaction,
    round(avg(Revenue), 4) as avg_order_value,
    min(SalesDate) as first_purchase_date,
    max(SalesDate) as last_purchase_date
from {{ ref('int_sales_metrics') }}
where SalesDate is not null
group by CustomerID
