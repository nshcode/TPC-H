-- ===========================
-- Volume Shipping Query (Q7)
-- ===========================
-- The query finds, for two given nations, the gross discounted revenues derived from lineitems in 
-- which parts were shipped from a supplier in either nation to a customer in the other nation 
-- during 1995 and 1996. 
-- The query lists the supplier nation, the customer nation, the year, and the revenue from shipments 
-- that took place in that year. The query orders the answer by Supplier nation, Customer nation, 
-- and year (all ascending).


select
    supp_nation
    ,cust_nation
    ,l_year
    ,round(sum(volume), 2) as revenue
from 
( 
    select 
        n1.n_name  as supp_nation
        ,n2.n_name as cust_nation
        ,extract(year from l_shipdate)      as l_year
        ,l_extendedprice * (1 - l_discount) as volume
    from 
        supplier
        join lineitem
            on l_suppkey = s_suppkey
        join orders
            on o_orderkey = l_orderkey
        join customer 
            on c_custkey = o_custkey
        join nation n1
            on n1.n_nationkey = s_nationkey
        join nation n2
            on n2.n_nationkey = c_nationkey
        where (n1.n_name = 'FRANCE' and n2.n_name = 'GERMANY')
            or
              (n1.n_name = 'GERMANY' and n2.n_name = 'FRANCE')
) shipping
group by 
    supp_nation
    ,cust_nation
    ,l_year
order by
    supp_nation
    ,cust_nation
    ,l_year
;
