-- ===============================
-- Discounted Revenue Query (Q19)
-- ===============================
-- The query finds the gross discounted revenue for all orders for three 
-- different types of parts that were shipped by air and delivered in person. 
-- Parts are selected based on the combination of specific brands, a list of 
-- containers, and a range of sizes.

select
    sum(l_extendedprice * (1 - l_discount) ) as revenue
from 
    lineitem
    ,part 
where 
    (
        p_partkey = l_partkey
        and p_brand = 'Brand#12'
        and p_container in ( 'SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
        and p_size between 1 and 5 
        and l_quantity >= 1 and l_quantity <= 1 + 10 
        and l_shipmode in ('AIR', 'AIR REG')
        and l_shipinstruct = 'DELIVER IN PERSON' 
    )
    or
    (
        p_partkey = l_partkey
        and p_brand = 'Brand#23'
        and p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
         and p_size between 1 and 10
        and l_quantity >= 10 and l_quantity <= 10 + 10
        and l_shipmode in ('AIR', 'AIR REG')
        and l_shipinstruct = 'DELIVER IN PERSON'
    )
    or
    (
        p_partkey = l_partkey
        and p_brand = 'Brand#34'
        and p_container in ( 'LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
        and p_size between 1 and 15
        and l_quantity >= 20 and l_quantity <= 20 + 10
        and l_shipmode in ('AIR', 'AIR REG')
        and l_shipinstruct = 'DELIVER IN PERSON'
    )
;