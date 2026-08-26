create table salesperson_performance_summary as
select SalesPersonName,
		SalesPersonID,
        sum(total_transactions) as total_transactions,
        sum(total_quantity) as total_quantity,
        sum(total_revenue) as total_revenue,
        ROUND(
        SUM(total_revenue) / NULLIF(COUNT(*), 0),
        4
    ) AS avg_revenue_per_transaction
from salesperson_monthly_summary
group by SalespersonID,
		SalesPersonName;