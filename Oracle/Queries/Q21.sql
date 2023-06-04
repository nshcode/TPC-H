-- ==============================================
-- Supplier Who Kept Orders Wainting Query (Q21)
-- ==============================================
-- The query identifies suppliers, for a given nation, whose product was part of 
-- a multi-supplier order (with current status of 'F') where they were the only
-- supplier who failed to meet the committed delivery date.

select
    s_name
    ,count(*) numwait
from orders
join lineitem l1
    on l1.l_orderkey = o_orderkey
join supplier
    on l1.l_suppkey = s_suppkey
join nation
    on n_nationkey = s_nationkey
    and n_name = 'SAUDI ARABIA'
where 1 = 1
    and o_orderstatus = 'F'
    and l1.l_receiptdate > l1.l_commitdate
    and exists (
                select *
                from lineitem l2
                where 1 = 1
                    and l2.l_orderkey = l1.l_orderkey
                    and l2.l_suppkey != l1.l_suppkey
            )
    and not exists (
                select *
                from lineitem l3
                where 1 = 1
                    and l3.l_orderkey = l1.l_orderkey
                    and l3.l_suppkey != l1.l_suppkey
                    and l3.l_receiptdate > l3.l_commitdate
            )
group by 
    s_name
order by 
    numwait desc
    ,s_name
fetch first 100 row only
;


