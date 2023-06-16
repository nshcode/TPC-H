
create table tpch_history (
    h_p_key  number(38)  not null
    ,h_s_key number(38)  not null
    ,h_o_key number(38)  not null
    ,h_l_key  number(38) not null
    ,h_delta number(38)  not null
    ,h_date_t timestamp  not null
    ,constraint history_pk 
        primary key (h_p_key, h_s_key, h_o_key)
    ,constraint history_part_fk
        foreign key (h_p_key) references part(p_partkey)
    ,constraint history_supplier_fk
        foreign key (h_s_key) references supplier(s_suppkey)
    ,constraint history_orders_fk 
        foreign key (h_o_key) references orders(o_orderkey)
)
;

truncate table tpch_history;
select * from tpch_history;