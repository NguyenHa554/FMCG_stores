
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select CategoryName
from "fmcg"."main"."monthly_category_revenue_summary"
where CategoryName is null



  
  
      
    ) dbt_internal_test