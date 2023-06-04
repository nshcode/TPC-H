-- =================================
-- Local Supplier Volume Query (Q5)
-- ================================
-- Q5 lists for each nation in a region the revenue volume that resulted from lineitem 
-- transactions in which the customer ordering parts and the supplier filling them were 
-- both within that nation. 
-- The query is run in order to determine whether to institute local distribution centers in a given region. 
-- The query considers only parts ordered in a given year. The query displays the nations and revenue volume 
-- in descending order by revenue. Revenue volume for all qualifying lineitems in a particular nation is
-- defined as sum(l_extendedprice * (1 -l_discount)).


select
    n_name
    ,sum(l_extendedprice * (1 - l_discount)) as revenue
from customer
join orders
    on c_custkey = o_custkey
join lineitem
    on o_orderkey = l_orderkey
join supplier
    on l_suppkey = s_suppkey
    and c_nationkey = s_nationkey
join nation
    on n_nationkey = s_nationkey
join region
    on n_regionkey = r_regionkey
where 
    1 = 1
    and r_name = 'ASIA'
    and o_orderdate >= to_date('1994-01-01','YYYY-MM-DD')
    and o_orderdate < to_date('1994-01-01','YYYY-MM-DD') + interval '1-0' year to month
group by 
    n_name
order by
    revenue desc
;