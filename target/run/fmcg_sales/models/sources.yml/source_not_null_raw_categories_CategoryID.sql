
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select CategoryID
from "fmcg"."raw"."categories"
where CategoryID is null



  
  
      
    ) dbt_internal_test