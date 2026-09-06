
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select SalesPersonID
from "fmcg"."main"."sales_person_monthly_agg"
where SalesPersonID is null



  
  
      
    ) dbt_internal_test