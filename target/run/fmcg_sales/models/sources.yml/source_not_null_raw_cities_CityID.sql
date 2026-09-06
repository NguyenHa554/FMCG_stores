
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select CityID
from "fmcg"."raw"."cities"
where CityID is null



  
  
      
    ) dbt_internal_test