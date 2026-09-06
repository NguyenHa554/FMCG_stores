
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    CustomerID as unique_field,
    count(*) as n_records

from "fmcg"."main"."sales_customer_agg"
where CustomerID is not null
group by CustomerID
having count(*) > 1



  
  
      
    ) dbt_internal_test