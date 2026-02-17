-- Exemplo mostrando a diferença entre ref() e source()
{{ config(materialized='view') }}

with seed_customers as (
    -- Usando ref() porque 'customers' é um SEED (gerenciado pelo dbt)
    select * from {{ ref('customers') }}
),

seed_orders as (
    -- Usando ref() porque 'orders' é um SEED (gerenciado pelo dbt)
    select * from {{ ref('orders') }}
),

final as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.signup_date,
        count(o.order_id) as total_orders,
        sum(o.total_amount) as total_spent
    from seed_customers as c
    left join seed_orders as o
        on c.customer_id = o.customer_id
    group by
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.signup_date
)

select * from final
