-- ======================================
-- Global Sales Opportunity Query (Q22)
-- ======================================
-- This query counts how many customers within a specific range of country codes
-- have not placed orders for 7 years but who have a greater than average �positive� 
-- account balance. It also reflects the magnitude of that balance. 
-- Country code is defined as the first two characters of c_phone.

select
    cntrycode 
    ,count(*)                 as numcust 
    ,round(sum(c_acctbal), 2) as totacctbal
from 
(
    select 
        substr(c_phone, 1, 2) as cntrycode
        ,c_acctbal
    from customer
    where 1 = 1
        and substr(c_phone, 1, 2) in (13,31,23,29,30,18,17)
        and c_acctbal > (
                            select avg(c_acctbal)
                            from customer
                            where c_acctbal > 0.0
                                and substr(c_phone, 1, 2) in (13,31,23,29,30,18,17)
                        )
        and not exists (
                        select 1 
                        from orders
                        where o_custkey = c_custkey
                        )
) custsale
group by 
    cntrycode
order by 
    cntrycode
;