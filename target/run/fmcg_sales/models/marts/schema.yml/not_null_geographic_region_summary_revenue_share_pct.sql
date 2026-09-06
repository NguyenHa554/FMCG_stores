
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select revenue_share_pct
from "fmcg"."main"."geographic_region_summary"
where revenue_share_pct is null



  
  
      
    ) dbt_internal_test