-- models/customer_order_report.sql

SELECT 
    c.c_name AS customer_name, 
    c.c_acctbal AS customer_balance, 
    o.o_orderkey AS order_id, 
    o.o_orderdate AS order_date, 
    o.o_totalprice AS total_amount, 
    l.l_partkey AS part_id, 
    l.l_quantity AS quantity, 
    l.l_extendedprice AS extended_price, 
    l.l_discount AS discount, 
    l.l_extendedprice * (1 - l.l_discount) AS item_total, 
    (SELECT COUNT(*) FROM {{ source('tpch', 'orders') }} o2 WHERE o2.o_custkey = c.c_custkey) AS total_orders, 
    (SELECT SUM(o_totalprice) FROM {{ source('tpch', 'orders') }} o3 WHERE o3.o_custkey = c.c_custkey) AS total_spent 
FROM 
    {{ source('tpch', 'customer') }} c 
JOIN 
    {{ source('tpch', 'orders') }} o ON c.c_custkey = o.o_custkey 
JOIN 
    {{ source('tpch', 'lineitem') }} l ON o.o_orderkey = l.l_orderkey 
WHERE 
    c.c_mktsegment = 'AUTOMOBILE' 
ORDER BY 
    c.c_name, o.o_orderdate, l.l_partkey
