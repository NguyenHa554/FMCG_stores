
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    SalesMonth as unique_field,
    count(*) as n_records

from "fmcg"."main"."monthly_revenue"
where SalesMonth is not null
group by SalesMonth
having count(*) > 1



  
  
      
    ) dbt_internal_test