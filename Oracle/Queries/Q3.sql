-- =============================
-- Shipping Priority Query (Q3)
-- =============================
-- This query retrieves the shipping priority and potential revenue, defined as the sum of 
-- l_extendedprice * (1-l_discount), of the orders having the largest revenue among those 
-- that had not been shipped as of a given date. Orders are listed in decreasing order of revenue. 
-- If more than 10 unshipped orders exist, only the 10 orders with the largest revenue are listed.

select 
    o_orderkey
    ,o_orderdate
    ,o_shippriority
    ,sum(l_extendedprice * (1 - l_discount)) as revenue
from customer
join orders
    on c_custkey = o_custkey
join lineitem 
    on o_orderkey = l_orderkey
where 
    1 = 1
    and c_mktsegment = 'BUILDING'
    and o_orderdate < to_date('1995-03-15', 'YYYY-MM-DD')
    and l_shipdate > to_date('1995-03-15', 'YYYY-MM-DD')
group by
    o_orderkey
    ,o_orderdate
    ,o_shippriority
order by 
    revenue desc
    ,o_orderdate
fetch first 10 row only;