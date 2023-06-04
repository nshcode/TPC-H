-- ===================================
-- Order Priority Checking Query (Q4)
-- ===================================
-- The query counts the number of orders ordered in a given quarter of a given year in which 
-- at least one lineitem was received by the customer later than its committed date. 
-- The query lists the count of such orders for each order priority sorted in ascending priority order.

select
    o_orderpriority
    ,count(o_orderkey) as order_count
from orders
where 
    1 = 1
    and  o_orderdate >= to_date('1993-07-01', 'YYYY-MM-DD')
    and o_orderdate < add_months(to_date('1993-07-01', 'YYYY-MM-DD'), 3)
    and exists (select 1
                from lineitem
                where 
                    l_orderkey = o_orderkey
                    and l_commitdate < l_receiptdate
                )
group by 
    o_orderpriority
order by
    o_orderpriority
;
