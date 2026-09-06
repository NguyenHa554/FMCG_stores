
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select SalesPersonName
from "fmcg"."main"."salesperson_monthly_summary"
where SalesPersonName is null



  
  
      
    ) dbt_internal_test