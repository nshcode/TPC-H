-- =============================
-- Promotion Effect Query (Q14)
-- =============================
-- The query determines what percentage of the revenue in a given year and month was derived from 
-- promotional parts. The query considers only parts actually shipped in that month and gives the 
-- percentage. Revenue is defined as (l_extendedprice * (1-l_discount)).

select
    round(
        sum(case
                when p_type like 'PROMO%'
                then l_extendedprice * (1 - l_discount)
                else 0
            end
            ) * 100.00 / sum (l_extendedprice * (1 - l_discount))
        ,2) as promo_revenue
from lineitem
join part
    on l_partkey = p_partkey
where l_shipdate >= to_date('1995-09-01', 'YYYY-MM-DD')
    and l_shipdate < add_months(to_date('1995-09-01', 'YYYY-MM-DD'), 1)
;