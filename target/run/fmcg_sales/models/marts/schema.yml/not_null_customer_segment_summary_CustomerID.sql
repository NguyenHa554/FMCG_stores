
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select CustomerID
from "fmcg"."main"."customer_segment_summary"
where CustomerID is null



  
  
      
    ) dbt_internal_test