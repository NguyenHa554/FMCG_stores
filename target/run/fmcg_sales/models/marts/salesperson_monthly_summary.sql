
  
    

  create  table
    `sales_of_fmcg_stores`.`salesperson_monthly_summary__dbt_tmp`
    
    
      as
    
    (
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
from `sales_of_fmcg_stores`.`sales_person_monthly_agg` spma
join `sales_of_fmcg_stores`.`stg_employees` e
    on spma.SalesPersonID = e.EmployeeID
    )

  