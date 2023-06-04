-- =======================
-- Primary-Key Constraints
-- =======================
alter table region 
    add constraints pk_region primary key (r_regionkey)
;
alter table nation 
    add constraints pk_nation primary key (n_nationkey)
;
alter table lineitem
    add constraints pk_lineitem primary key (l_orderkey, l_linenumber)
;
alter table orders
    add constraints pk_orders primary key (o_orderkey)
;
alter table customer
    add constraints pk_customer primary key (c_custkey)
;
alter table partsupp
    add constraints pk_partsupp primary key (ps_partkey, ps_suppkey)
;
alter table supplier
    add constraints pk_supplier primary key (s_suppkey)
;
alter table part 
    add constraints pk_part primary key (p_partkey)
;

-- ========================
-- Foreign-Key Constraints
-- ========================
alter table supplier
    add constraints fk_supplier_nation foreign key (s_nationkey)
        references nation(n_nationkey)
;
alter table partsupp
    add constraints fk_partsupp_part foreign key (ps_partkey)
        references part(p_partkey)
;
alter table partsupp
    add constraints fk_partsupp_supplier foreign key (ps_suppkey)
        references supplier(s_suppkey)
;
alter table customer
    add constraints fk_customer_nation foreign key (c_nationkey)
        references nation(n_nationkey)
;
alter table orders
    add constraints fk_orders_customer foreign key (o_custkey)
        references customer(c_custkey)
;
alter table lineitem 
    add constraints fk_lineitem_orders foreign key (l_orderkey)
        references orders(o_orderkey)
;
alter table lineitem 
    add constraints fk_lineitem_part_supplier foreign key (l_partkey, l_suppkey)
        references partsupp(ps_partkey, ps_suppkey)
;
alter table nation
    add constraints fk_nation_region foreign key (n_regionkey)
        references region(r_regionkey)
;

-- ===================
-- Check Constraints
-- ===================
alter table part
    add constraints ck_part_partkey_positive check (p_partkey >= 0)
;
alter table part
    add constraints ck_part_size_positive check (p_size >= 0)
;
alter table part
    add constraints ck_part_retailprice_positive check (p_retailprice >= 0)
;
alter table supplier
    add constraints ck_supplier_suppkey_positive check (s_suppkey >= 0)
;
alter table partsupp
    add constraints ck_partsupp_availqty_positive check(ps_availqty >= 0)
;
alter table partsupp
    add constraints ck_partsupp_supplycost_positive check(ps_supplycost >= 0)
;
alter table customer
    add constraints ck_customer_custkey_positive check (c_custkey >= 0)
;
alter table orders
    add constraints ck_orders_totalprice_positive check (o_totalprice >= 0)
;
alter table lineitem
    add constraints ck_lineitem_quantity_positive check (l_quantity >= 0)
;
alter table lineitem
    add constraints ck_lineitem_extendedprice_positive check (l_extendedprice >= 0)
;
alter table lineitem
    add constraints ck_lineitem_tax_positive check (l_tax >= 0)
;
alter table nation
    add constraints ck_nation_nationkey_positive check (n_nationkey >= 0)
;
alter table region
    add constraints ck_region_regionkey_positive check (r_regionkey >= 0)
;
alter table lineitem
    add constraints ck_lineitem_discount_boundaries check(l_discount between 0.0 and 1.0)
;
alter table lineitem
    add constraints ck_lineitem_shipdate_before_receiptdate check(l_shipdate <= l_receiptdate)
;


