
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select CustomerID
from "fmcg"."raw"."sales"
where CustomerID is null



  
  
      
    ) dbt_internal_test