-- ====================================
-- Returned Item Reporting Query (Q10)
-- ====================================
-- It finds the top 20 customers, in terms of their effect on lost revenue for a given 
-- quarter, who have returned parts. The query considers only parts that were ordered 
-- in the specified quarter. The query lists the customer's name, address, nation, phone number, 
-- account balance, comment information and revenue lost. The customers are listed in descending
-- order of lost revenue. Revenue lost is defined as sum(l_extendedprice*(1-l_discount)) 
-- for all qualifying lineitems.

select
    c_custkey
    ,c_name
    ,c_acctbal
    ,c_phone
    ,n_name
    ,c_address
    ,c_comment
    ,round( 
        sum(l_extendedprice * (1- l_discount)), 2)
    as revenue
from customer
join orders
    on o_custkey = c_custkey
join nation
    on n_nationkey = c_nationkey
join lineitem
    on l_orderkey = o_orderkey
where 1 = 1
    and l_returnflag = 'R'
    and o_orderdate >= to_date('1993-10-01', 'YYYY-MM-DD')
    and o_orderdate <  add_months(to_date('1993-10-01', 'YYYY-MM-DD'), 3)
group by
    c_custkey
    ,c_name
    ,c_acctbal
    ,c_phone
    ,n_name
    ,c_address
    ,c_comment
order by 
    revenue desc
fetch first 20 row only
;