
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select SalesMonth
from "fmcg"."main"."salesperson_monthly_summary"
where SalesMonth is null



  
  
      
    ) dbt_internal_test