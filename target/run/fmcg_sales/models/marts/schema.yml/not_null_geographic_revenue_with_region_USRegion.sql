
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select USRegion
from "fmcg"."main"."geographic_revenue_with_region"
where USRegion is null



  
  
      
    ) dbt_internal_test