-- Modelo que combina clientes com seus pedidos
{{ config(materialized='view') }}

select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.signup_date,
    count(o.order_id) as total_orders,
    sum(o.total_amount) as total_spent
from {{ ref('customers') }} as c
left join {{ ref('orders') }} as o
    on c.customer_id = o.customer_id
group by
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.signup_date
