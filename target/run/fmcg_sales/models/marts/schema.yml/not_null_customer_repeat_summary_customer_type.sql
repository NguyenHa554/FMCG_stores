
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_type
from "fmcg"."main"."customer_repeat_summary"
where customer_type is null



  
  
      
    ) dbt_internal_test