
  create view `sales_of_fmcg_stores`.`stg_sales__dbt_tmp`
    
    
  as (
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
from `sales_of_fmcg_stores`.`sales`
  );