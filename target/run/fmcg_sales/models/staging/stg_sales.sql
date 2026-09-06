
  
  create view "fmcg"."main"."stg_sales__dbt_tmp" as (
    select
    SalesID,
    SalesPersonID,
    CustomerID,
    ProductID,
    Quantity,
    Discount,
    TotalPrice,
    SalesDate,
    TransactionNumber
from "fmcg"."raw"."sales"
  );
