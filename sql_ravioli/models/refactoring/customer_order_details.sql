WITH customer_totals_cte AS (
    SELECT * FROM {{ ref('customer_order_summary') }}
),

customer_orders_cte AS (
    SELECT
        c.c_custkey AS customer_id,
        c.c_name AS customer_name,
        c.c_acctbal AS customer_balance,
        o.o_orderkey AS order_id,
        o.o_orderdate AS order_date,
        o.o_totalprice AS total_amount,
        ct.total_orders,
        ct.total_spent
    FROM 
        {{ source('tpch', 'customer') }} c
    JOIN 
        {{ source('tpch', 'orders') }} o ON c.c_custkey = o.o_custkey
    LEFT JOIN 
        customer_totals_cte ct ON c.c_custkey = ct.customer_id
    WHERE 
        c.c_mktsegment = 'AUTOMOBILE'
)

SELECT * FROM customer_orders_cte
