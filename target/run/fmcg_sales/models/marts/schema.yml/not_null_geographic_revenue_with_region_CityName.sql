
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select CityName
from "fmcg"."main"."geographic_revenue_with_region"
where CityName is null



  
  
      
    ) dbt_internal_test