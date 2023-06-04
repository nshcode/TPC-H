-- ==============================================
-- Shipping Modes and Order Priority Query (Q12)
-- ==============================================
-- Q12 counts, by ship mode, for lineitems actually received by customers in a given year, 
-- the number of lineitems belonging to orders for which the l_receiptdate exceeds the l_commitdate 
-- for two different specified ship modes. Only lineitems that were actually shipped before the 
-- l_commitdate are considered. The late lineitems are partitioned into two groups, 
-- those with priority URGENT or HIGH, and those with a priority other than URGENT or HIGH.

select
    l_shipmode
    ,sum(case 
            when o_orderpriority = '1-URGENT' 
                or o_orderpriority = '2-HIGH'
            then 1
            else 0
        end
        ) as high_line_count
    ,sum(case 
            when o_orderpriority <> '1-URGENT' 
                and o_orderpriority <> '2-HIGH'
            then 1
            else 0
        end
        ) as low_line_count
from orders
join lineitem
    on o_orderkey = l_orderkey
where 1 = 1
    and l_shipmode in ('MAIL', 'SHIP')
    and l_commitdate < l_receiptdate
    and l_shipdate < l_commitdate
    and l_receiptdate >= to_date('1994-01-01', 'YYYY-MM-DD')
    and l_receiptdate < to_date('1994-01-01', 'YYYY-MM-DD') 
                        + interval '1-0' year to month
group by 
    l_shipmode
order by 
    l_shipmode
;