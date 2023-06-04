insert into region (
    r_regionkey
    ,r_name
    ,r_comment
)
select 
    r_regionkey
    ,r_name
    ,r_comment
from region_ext
;

insert into nation (
    n_nationkey 
    ,n_name
    ,n_regionkey
    ,n_comment
)
select 
    n_nationkey 
    ,n_name
    ,n_regionkey
    ,n_comment
from nation_ext
;

insert into customer 
    (c_custkey
    ,c_name
    ,c_address
    ,c_nationkey
    ,c_phone
    ,c_acctbal
    ,c_mktsegment
    ,c_comment
) 
select 
    c_custkey
    ,c_name
    ,c_address
    ,c_nationkey
    ,c_phone
    ,c_acctbal
    ,c_mktsegment
    ,c_comment
from customer_ext
;

insert into part (
    p_partkey
    ,p_name
    ,p_mfgr
    ,p_brand
    ,p_type
    ,p_size
    ,p_container
    ,p_retailprice
    ,p_comment
)
select 
    p_partkey
    ,p_name
    ,p_mfgr
    ,p_brand
    ,p_type
    ,p_size
    ,p_container
    ,p_retailprice
    ,p_comment
from part_ext;

insert into  supplier (
    s_suppkey
    ,s_name
    ,s_address
    ,s_nationkey
    ,s_phone
    ,s_acctbal
    ,s_comment
)
select 
    s_suppkey
    ,s_name
    ,s_address
    ,s_nationkey
    ,s_phone
    ,s_acctbal
    ,s_comment
from supplier_ext
;

insert into partsupp (
    ps_partkey
    ,ps_suppkey
    ,ps_availqty
    ,ps_supplycost
    ,ps_comment
)
select 
    ps_partkey
    ,ps_suppkey
    ,ps_availqty
    ,ps_supplycost
    ,ps_comment
from partsupp_ext;

insert into orders (
    o_orderkey
    ,o_custkey 
    ,o_orderstatus
    ,o_totalprice
    ,o_orderdate
    ,o_orderpriority
    ,o_check
    ,o_shippriority
    ,o_comment
)
select 
    o_orderkey
    ,o_custkey 
    ,o_orderstatus
    ,o_totalprice
    ,to_date(o_orderdate, 'YYYY-MM-DD')
    ,o_orderpriority
    ,o_check
    ,o_shippriority
    ,o_comment
from orders_ext
;

insert into lineitem (
    l_orderkey
    ,l_partkey
    ,l_suppkey
    ,l_linenumber
    ,l_quantity
    ,l_extendedprice
    ,l_discount
    ,l_tax
    ,l_returnflag
    ,l_linestatus
    ,l_shipdate
    ,l_commitdate
    ,l_receiptdate
    ,l_shipinstruct 
    ,l_shipmode
    ,l_comment
)
select 
    l_orderkey
    ,l_partkey
    ,l_suppkey
    ,l_linenumber
    ,l_quantity
    ,l_extendedprice
    ,l_discount
    ,l_tax
    ,l_returnflag
    ,l_linestatus
    ,to_date(l_shipdate,    'YYYY-MM-DD')
    ,to_date(l_commitdate,  'YYYY-MM-DD')
    ,to_date(l_receiptdate, 'YYYY-MM-DD')
    ,l_shipinstruct 
    ,l_shipmode
    ,l_comment
from lineitem_ext
;

commit;