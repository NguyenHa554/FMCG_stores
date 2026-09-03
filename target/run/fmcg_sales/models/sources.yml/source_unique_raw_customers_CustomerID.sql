select
      count(*) as failures,
      case
        when count(*) <> 0 then 'true'
        else 'false'
      end as should_warn,
      case
        when count(*) <> 0 then 'true'
        else 'false'
      end as should_error
    from (
      
    
    

select
    CustomerID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`customers`
where CustomerID is not null
group by CustomerID
having count(*) > 1



      
    ) dbt_internal_test