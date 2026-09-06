
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select ProductID
from "fmcg"."raw"."sales"
where ProductID is null



  
  
      
    ) dbt_internal_test