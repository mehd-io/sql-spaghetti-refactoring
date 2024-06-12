WITH customer_orders_cte AS (
    SELECT * FROM {{ ref('customer_order_details') }}
)

SELECT
    co.customer_name,
    co.customer_balance,
    co.order_id,
    co.order_date,
    co.total_amount,
    co.total_orders,
    co.total_spent,
    l.l_partkey AS part_id,
    l.l_quantity AS quantity,
    l.l_extendedprice AS extended_price,
    l.l_discount AS discount,
    l.l_extendedprice * (1 - l.l_discount) AS item_total
FROM 
    customer_orders_cte co
JOIN 
    {{ source('tpch', 'lineitem') }} l ON co.order_id = l.l_orderkey
ORDER BY 
    customer_name, order_date, part_id
