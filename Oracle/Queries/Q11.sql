-- ===========================================
-- Important Stock Identification Query (Q11)
-- ===========================================
-- the query finds, from scanning the available stock of suppliers in a given nation, all 
-- the parts that represent a significant percentage of the total value of all available parts. 
-- The query displays the part number and the value of those parts in descending order of value.

select
    ps_partkey
    ,sum(ps_supplycost * ps_availqty) as value
from partsupp
join supplier
    on s_suppkey = ps_suppkey
join nation
    on n_nationkey = s_nationkey
where n_name = 'GERMANY'
group by ps_partkey
having 
    (
        sum(ps_supplycost * ps_availqty)
        >
        (
            select 
                sum (ps_supplycost * ps_availqty) * 0.0001
            from partsupp
            join supplier
                    on s_suppkey = ps_suppkey
            join nation
                    on n_nationkey = s_nationkey
            where n_name = 'GERMANY'
        )
    )
order by value desc
;