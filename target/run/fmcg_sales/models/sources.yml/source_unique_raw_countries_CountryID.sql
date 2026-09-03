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
    CountryID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`countries`
where CountryID is not null
group by CountryID
having count(*) > 1



      
    ) dbt_internal_test