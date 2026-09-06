
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select CountryID
from "fmcg"."raw"."countries"
where CountryID is null



  
  
      
    ) dbt_internal_test