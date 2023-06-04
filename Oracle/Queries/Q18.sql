-- ==================================
-- Large Volume Customer Query (Q18)
-- ==================================
-- The query finds a list of the top 100 customers who have ever 
-- placed large quantity orders. The query lists the customer name, 
-- customer key, the order key, date and total price and the quantity for the order.


select
    c_name
    ,c_custkey 
    ,o_orderkey
    ,o_orderdate
    ,o_totalprice
    ,sum(l_quantity)
from customer
join orders
    on o_custkey = c_custkey
join lineitem
    on o_orderkey = l_orderkey
where 1 = 1
    and o_orderkey in (
                        select l_orderkey
                        from lineitem
                        group by l_orderkey
                        having sum(l_quantity) > 30
                    )
group by
    c_name
    ,c_custkey
    ,o_orderkey 
    ,o_orderdate
    ,o_totalprice
order by 
    o_totalprice desc
    ,o_orderdate
fetch first 100 row only
;
