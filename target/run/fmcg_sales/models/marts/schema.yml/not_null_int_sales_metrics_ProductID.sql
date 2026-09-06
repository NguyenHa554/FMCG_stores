
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select ProductID
from "fmcg"."main"."int_sales_metrics"
where ProductID is null



  
  
      
    ) dbt_internal_test