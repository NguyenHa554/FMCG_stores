
    
    

select
    SalesMonth as unique_field,
    count(*) as n_records

from "fmcg"."main"."monthly_revenue"
where SalesMonth is not null
group by SalesMonth
having count(*) > 1


