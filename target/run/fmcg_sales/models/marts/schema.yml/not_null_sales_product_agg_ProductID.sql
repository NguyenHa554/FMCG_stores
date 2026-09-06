
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select ProductID
from "fmcg"."main"."sales_product_agg"
where ProductID is null



  
  
      
    ) dbt_internal_test