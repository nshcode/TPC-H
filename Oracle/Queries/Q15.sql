-- =========================
-- Top Supplier Query (Q15)
-- =========================
-- This query finds the supplier who contributed the most to the overall revenue 
-- for parts shipped during a given quarter of a given year. In case of a tie, 
-- the query lists all suppliers whose contribution was equal to the maximum, presented 
-- in supplier number order.

select 
    s_suppkey
    ,s_name
    ,s_address
    ,s_phone
    ,round(sum_revenue, 2) total_revenue
from 
(
    select 
        l_suppkey
        ,sum(l_extendedprice * (1 - l_discount)) as sum_revenue
        ,dense_rank() 
            over (order by sum(l_extendedprice * (1 - l_discount)) desc) 
        as rank_sum_revenue
    from lineitem
    where 1 = 1
        and l_shipdate >= to_date('1996-01-01', 'YYYY-MM-DD')
        and l_shipdate < add_months(to_date('1996-01-01', 'YYYY-MM-DD'), 3)
    group by l_suppkey
) r_sum_revenue
join supplier
    on s_suppkey = l_suppkey
where rank_sum_revenue = 1
;