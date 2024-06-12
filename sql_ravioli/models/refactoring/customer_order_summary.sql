WITH orders_cte AS (
    SELECT 
        o_custkey AS customer_id,
        COUNT(*) AS total_orders,
        SUM(o_totalprice) AS total_spent
    FROM 
        {{ source('tpch', 'orders') }}
    GROUP BY 
        o_custkey
)

SELECT * FROM orders_cte
