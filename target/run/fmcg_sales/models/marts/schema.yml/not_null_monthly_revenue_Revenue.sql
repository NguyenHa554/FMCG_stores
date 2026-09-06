
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select Revenue
from "fmcg"."main"."monthly_revenue"
where Revenue is null



  
  
      
    ) dbt_internal_test