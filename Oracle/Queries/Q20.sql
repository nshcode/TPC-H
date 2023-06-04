-- =====================================
-- Potential Part Promotion Query (Q20)
-- =====================================
-- Q20 identifies suppliers who have an excess of a given part available; 
-- an excess is defined to be more than 50% of the parts like the given part 
-- that the supplier shipped in a given year for a given nation. 
-- Only parts whose names share a certain naming convention are considere.

select
    s_name
    ,s_address
from supplier
join nation 
    on s_nationkey = n_nationkey
    and n_name = 'CANADA'
where 
    s_suppkey in (
                    select ps_suppkey
                    from partsupp
                    where 1 = 1
                        and ps_partkey in (
                                            select p_partkey
                                            from part
                                            where p_name like 'forest%'
                                        )
                        and ps_availqty > (
                                            select 0.5 * sum(l_quantity)
                                            from lineitem
                                            where 1 = 1
                                                and l_partkey = ps_partkey
                                                and l_suppkey = ps_suppkey
                                                and l_shipdate >= to_date('1994-01-01', 'YYYY-MM-DD')
                                                and l_shipdate < to_date('1994-01-01', 'YYYY-MM-DD')
                                                                + interval '1-0' year to month
                                        )
                ) 
order by s_name
;