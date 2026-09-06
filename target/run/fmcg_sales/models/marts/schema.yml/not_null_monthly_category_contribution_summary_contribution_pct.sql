
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select contribution_pct
from "fmcg"."main"."monthly_category_contribution_summary"
where contribution_pct is null



  
  
      
    ) dbt_internal_test