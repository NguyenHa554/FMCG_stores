
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    SalesID as unique_field,
    count(*) as n_records

from "fmcg"."main"."int_sales_metrics"
where SalesID is not null
group by SalesID
having count(*) > 1



  
  
      
    ) dbt_internal_test