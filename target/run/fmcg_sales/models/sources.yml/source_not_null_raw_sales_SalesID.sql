
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select SalesID
from "fmcg"."raw"."sales"
where SalesID is null



  
  
      
    ) dbt_internal_test