-- ================================
-- Minimum Cost Supplier Query (Q2)
-- ================================
-- Q2 finds, in a given region, for each part of a certain type and size, the supplier who 
-- can supply it at minimum cost. If several suppliers in that region offer the desired part 
-- type and size at the same (minimum) cost, the query lists the parts from suppliers with 
-- the 100 highest account balances. For each supplier, the query lists the supplier's account balance, 
-- name and nation; the part's number and manufacturer; the supplier's address, phone number and comment 
-- information.

select
    s_acctbal
    ,s_name
    ,n_name
    ,p_partkey
    ,p_mfgr
    ,s_address
    ,s_phone
    ,s_comment
    ,min(ps_supplycost) over (partition by p_type) min
    ,max(ps_supplycost) over (partition by p_type) max
    ,p_type
from supplier
join partsupp
    on s_suppkey = ps_suppkey
join part
    on p_partkey = ps_partkey
join nation
    on n_nationkey = s_nationkey
join region
    on r_regionkey = n_regionkey
where 1 = 1
    and r_name = 'EUROPE'
    and p_type like '%BRASS'
    and p_size = 15
    and ps_supplycost = (select min (ps_supplycost) 
                        from supplier
                        join partsupp
                            on s_suppkey = ps_suppkey
                        join nation
                            on n_nationkey = s_nationkey
                        join region
                            on r_regionkey = n_regionkey
                        where r_name = 'EUROPE'
                            and p_partkey = ps_partkey)
order by
    p_type
    ,s_acctbal desc 
fetch first 100 row only
;
