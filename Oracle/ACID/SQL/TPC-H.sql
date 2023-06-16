select * from billing_headers;

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
) values
(
     :o_orderkey
    ,:o_custkey 
    ,:o_orderstatus
    ,:o_totalprice
    ,:o_orderdate
    ,:o_orderpriority
    ,:o_check
    ,:o_shippriority
    ,:o_comment
)
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
values 
    (
    :l_orderkey
    ,:l_partkey  
    ,:l_suppkey
    ,:l_linenumber
    ,:l_quantity
    ,:l_extendedprice
    ,:l_discount
    ,:l_tax
    ,:l_returnflag
    ,:l_linestatus
    ,:l_shipdate
    ,:l_commitdate
    ,:l_receiptdate
    ,:l_shipinstruct
    ,:l_shipmode
    ,:l_comment
    )
;

select max(o_orderkey) from orders; -- 6000000
select count(*) from orders; --1500000
select max(l_orderkey) from lineitem; --600000
select count(*) - 6001215 from lineitem; -- 6001215