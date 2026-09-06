{{
    config(
        materialized='table',
        pre_hook="{{ mysql_create_index_if_not_exists('raw', 'sales', 'idx_sales_metrics_load', 'SalesDate, ProductID, CustomerID, SalesPersonID, Quantity, Discount') }}",
        post_hook=[
            "{{ mysql_create_model_index_if_not_exists('idx_int_sales_metrics_month', 'SalesMonth') }}",
            "{{ mysql_create_model_index_if_not_exists('idx_int_sales_metrics_product', 'ProductID') }}",
            "{{ mysql_create_model_index_if_not_exists('idx_int_sales_metrics_customer', 'CustomerID') }}",
            "{{ mysql_create_model_index_if_not_exists('idx_int_sales_metrics_person_month', 'SalesPersonID, SalesMonth') }}",
            "{{ mysql_create_model_index_if_not_exists('idx_int_sales_metrics_month_product', 'SalesMonth, ProductID') }}"
        ]
    )
}}

-- Narrow transaction-level fact table for MySQL analytics.
-- This materializes the product join and revenue calculation once so downstream
-- aggregates do not repeatedly scan sales and join products.
select
    s.SalesID,
    s.SalesDate,
    date_format(s.SalesDate, '%Y-%m') as SalesMonth,
    s.ProductID,
    s.CustomerID,
    s.SalesPersonID,
    s.Quantity,
    s.Discount,
    s.Quantity * p.Price * (1 - s.Discount) as Revenue
from {{ source('raw', 'sales') }} s
join {{ source('raw', 'products') }} p
    on s.ProductID = p.ProductID
