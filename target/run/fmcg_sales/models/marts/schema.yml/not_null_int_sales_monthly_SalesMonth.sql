
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select SalesMonth
from "fmcg"."main"."int_sales_monthly"
where SalesMonth is null



  
  
      
    ) dbt_internal_test