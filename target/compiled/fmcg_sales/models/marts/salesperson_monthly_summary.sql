select
    spma.SalesMonth,
    e.EmployeeID as SalesPersonID,
    concat(e.FirstName, ' ', e.LastName) as SalesPersonName,
    e.Gender,
    e.HireDate,
    spma.total_transactions,
    spma.total_quantity,
    spma.total_revenue,
    spma.avg_revenue_per_transaction
from "fmcg"."main"."sales_person_monthly_agg" spma
join "fmcg"."main"."stg_employees" e
    on spma.SalesPersonID = e.EmployeeID