-- ========================
-- Create external tables
-- ========================
-- part_ext
-- supplier_ext
-- partsupp_ext
-- lineitem_ext 
-- orders_ext
-- customer_ext
-- nation_ext 
-- region_ext

create table part_ext (
    p_partkey     number(38) not null
    ,p_name        varchar2(55 char)
    ,p_mfgr        char(25 char)
    ,p_brand       char(10 char)
    ,p_type        varchar2(25 char)
    ,p_size        number(38)
    ,p_container   char(10 char)
    ,p_retailprice number(38, 5)
    ,p_comment     varchar2(23 char)
)
organization external ( 
    type oracle_loader
    default directory tpch_dir
    access parameters
    (FIELDS TERMINATED BY '|')
    location ('part.tbl')
)
;

create table supplier_ext (
    s_suppkey    number(38) not null
    ,s_name      char(25 char)
    ,s_address   varchar2(40 char)
    ,s_nationkey number(38)
    ,s_phone     char(15 char)
    ,s_acctbal   number(38, 5)
    ,s_comment   varchar2(101 char)
)
organization external ( 
    type oracle_loader
    default directory tpch_dir
    access parameters
    (FIELDS TERMINATED BY '|')
    location ('supplier.tbl')
)
;

create table partsupp_ext (
    ps_partkey     number(38) not null
    ,ps_suppkey    number(38) not null
    ,ps_availqty   number(38) not null
    ,ps_supplycost number(38, 5)
    ,ps_comment    varchar2(199 char)
)
organization external ( 
    type oracle_loader
    default directory tpch_dir
    access parameters
    (FIELDS TERMINATED BY '|')
    location ('partsupp.tbl')
)
;

create table customer_ext (
    c_custkey     number(38) not null
    ,c_name       varchar2(25 char)
    ,c_address    varchar2(40 char)
    ,c_nationkey  number(38)
    ,c_phone      char(15 char)
    ,c_acctbal    number(38,5)
    ,c_mktsegment char(10 char)
    ,c_comment    varchar2(117 char)
) 
organization external (
    type oracle_loader
    default directory tpch_dir
    access parameters
    (FIELDS TERMINATED BY '|')
    location ('customer.tbl')
)
;

create table orders_ext (
    o_orderkey       number(38) not null
    ,o_custkey       number(38) 
    ,o_orderstatus   char(1 char)
    ,o_totalprice    number(38, 5)
    ,o_orderdate     char(50 char)
    ,o_orderpriority char(15 char)
    ,o_check         char(15 char)
    ,o_shippriority  number(10)
    ,o_comment       varchar2(79 char)
)
organization external (
    type oracle_loader
    default directory tpch_dir 
    access parameters
    (FIELDS TERMINATED BY '|')
    location ('orders.tbl')
)
;

create table lineitem_ext (
    l_orderkey       number(38) not null
    ,l_partkey       number(38) not null
    ,l_suppkey       number(38) not null
    ,l_linenumber    number(10)
    ,l_quantity      number(38, 5)
    ,l_extendedprice number(38, 5)
    ,l_discount      number(38, 5)
    ,l_tax           number(38, 5)
    ,l_returnflag    char(1 char)
    ,l_linestatus    char(1 char)
    ,l_shipdate      char(50 char)
    ,l_commitdate    char(50 char)
    ,l_receiptdate   char(50 char) 
    ,l_shipinstruct  char(25 char)
    ,l_shipmode      char(10 char)
    ,l_comment       varchar2(44 char)
)
organization external ( 
    type oracle_loader
    default directory tpch_dir
    access parameters
    (FIELDS TERMINATED BY '|')
    location ('lineitem.tbl')
)
;

create table nation_ext(
    n_nationkey  number(38) not null
    ,n_name      char(25 char)
    ,n_regionkey number(38)
    ,n_comment   varchar2(152 char)
)
organization external (
    type oracle_loader
    default directory tpch_dir 
    access parameters
    (FIELDS TERMINATED BY '|')
    location ('nation.tbl')
)
;

create table region_ext(
    r_regionkey number(38)
    ,r_name     char(25 char)
    ,r_comment  varchar2(152 char)
)
organization external (
    type oracle_loader
    default directory tpch_dir 
    access parameters
    (FIELDS TERMINATED BY '|')
    location ('region.tbl')
)
;

