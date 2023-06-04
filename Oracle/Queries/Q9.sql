-- =======================================
-- Product Type Profit Measure Query (Q9)
-- =======================================
-- Q9  finds, for each nation and each year, the profit for all parts ordered in that 
-- year that contain a specified substring in their names and that were filled by a supplier in that nation. 
-- The profit is defined as the sum of [(l_extendedprice*(1-l_discount)) - (ps_supplycost * l_quantity)] 
-- for all lineitems describing parts in the specified line. 
-- The query lists the nations in ascending alphabetical order and, for each nation, the year and profit 
-- in descending order by year (most recent first).

select
    nation
    ,o_year
    ,sum(amount) as sum_profit
from 
(
    select
        n_name                              as nation
        ,extract(year from o_orderdate)     as o_year
        ,(l_extendedprice * (1 - l_discount))
         - (ps_supplycost * l_quantity)    as amount
    from lineitem
    join supplier
        on l_suppkey = s_suppkey
    join part
        on l_partkey = p_partkey
    join partsupp
        on s_suppkey = ps_suppkey
        and p_partkey = ps_partkey
    join orders
        on o_orderkey = l_orderkey
    join nation
        on n_nationkey = s_nationkey
    where 1 = 1
        and p_name like '%green%'
)  profit
group by 
    nation
    ,o_year
order by 
    nation
    ,o_year desc
;
