
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select EmployeeID
from "fmcg"."raw"."employees"
where EmployeeID is null



  
  
      
    ) dbt_internal_test