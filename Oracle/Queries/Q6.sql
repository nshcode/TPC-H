-- ======================================
-- Forecasting Revenue Change Query (Q6)
-- ======================================
-- This query quantifies the amount of revenue increase that would have resulted from
-- eliminating certain companywide discounts in a given percentage range in a given year. 
-- Asking this type of "what if" query can be used to look for ways to increase revenues.

select 
    round(sum(l_extendedprice * l_discount), 2) as revenue
from
    lineitem
where 
    1 = 1
    and l_shipdate >= to_date('1994-01-01', 'YYYY-MM-DD')
    and l_shipdate < to_date('1994-01-01', 'YYYY-MM-DD') + interval '1-0' year to month
    and l_discount between (0.06 - 0.01) and (0.06 + 0.01)
    and l_quantity < 24
;