
    
    

select
    ProductID as unique_field,
    count(*) as n_records

from "fmcg"."main"."sales_product_agg"
where ProductID is not null
group by ProductID
having count(*) > 1


