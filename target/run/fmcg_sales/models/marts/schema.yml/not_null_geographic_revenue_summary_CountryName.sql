
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select CountryName
from "fmcg"."main"."geographic_revenue_summary"
where CountryName is null



  
  
      
    ) dbt_internal_test