
    
    

select
    SalesPersonID as unique_field,
    count(*) as n_records

from `sales_of_fmcg_stores`.`salesperson_performance_summary`
where SalesPersonID is not null
group by SalesPersonID
having count(*) > 1


