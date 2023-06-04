-- =================================
-- National Market Share Query (Q8) 
-- =================================
-- The market share for a given nation within a given region is defined as the fraction of the revenue, 
-- the sum of [l_extendedprice * (1-l_discount)], from the products of a specified type in that region 
-- that was supplied by suppliers from the given nation. 
-- The query determines this for the years 1995 and 1996 presented in this order.

select
    O_year
    ,round (sum(case 
                    when supp_nation = 'BRAZIL' 
                    then volume
                    else 0
                end) / sum(volume) 
            ,2) as mkt_share
from 
(
    select
        extract(year from o_orderdate)      as o_year
        ,l_extendedprice * (1 - l_discount) as volume
        ,n2.n_name                          as supp_nation
    from orders
    join lineitem
        on o_orderkey = l_orderkey
    join customer
        on c_custkey = o_custkey
    join part
        on p_partkey = l_partkey
    join supplier 
        on s_suppkey = l_suppkey
    join nation n1
        on n1.n_nationkey = c_nationkey
    join nation n2
        on n2.n_nationkey = s_nationkey
    join region 
        on r_regionkey = n1.n_regionkey
    where 1 = 1
        and p_type = 'ECONOMY ANODIZED STEEL'
        and r_name = 'AMERICA'
        and o_orderdate between to_date('1995-01-01', 'YYYY-MM-DD')
                            and to_date('1996-12-31', 'YYYY-MM-DD')                      
) all_nations
group by 
    o_year
order by 
    O_year
;

