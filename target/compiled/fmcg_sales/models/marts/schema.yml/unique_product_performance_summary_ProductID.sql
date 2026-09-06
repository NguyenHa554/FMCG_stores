
    
    

select
    ProductID as unique_field,
    count(*) as n_records

from "fmcg"."main"."product_performance_summary"
where ProductID is not null
group by ProductID
having count(*) > 1


