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
    EmployeeID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`employees`
where EmployeeID is not null
group by EmployeeID
having count(*) > 1



      
    ) dbt_internal_test