
    
    

select
    SalesPersonID as unique_field,
    count(*) as n_records

from "fmcg"."main"."salesperson_performance_summary"
where SalesPersonID is not null
group by SalesPersonID
having count(*) > 1


