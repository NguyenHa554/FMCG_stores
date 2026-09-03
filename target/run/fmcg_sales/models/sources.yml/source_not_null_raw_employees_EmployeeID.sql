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
      
    
    



select EmployeeID
from `sales_of_fmcg_stores`.`employees`
where EmployeeID is null



      
    ) dbt_internal_test