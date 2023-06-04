-- =================================
-- Pricing Summary Report Query (Q1)
-- =================================

set serveroutput on;

var DELTA number;
begin   
    :DELTA := trunc(dbms_random.value(60, 121), 0);
    dbms_output.put_line('DELTA=' || :DELTA);
end;
/

select 
    l_returnflag
    ,l_linestatus
    ,sum(l_quantity)      as sum_qty
    ,sum(l_extendedprice) as sum_base_price
    ,sum(l_extendedprice * (1 - l_discount))               as sum_disc_price
    ,sum(l_extendedprice * (1 - l_discount) * ( 1+ l_tax)) as sum_charge
    ,avg(l_quantity)      as avg_qty
    ,avg(l_extendedprice) as avg_price
    ,avg(l_discount)      as avg_disc
    ,count(*)             as count_order
from 
    lineitem
where 
    l_shipdate <= to_date('1998-12-01', 'YYYY-MM-DD') - :DELTA
group by 
    l_returnflag
    ,l_linestatus
order by
    l_returnflag
    ,l_linestatus
;

begin 
    dbms_output.put_line('Query is executed with:');
    dbms_output.put_line('DELTA=' || :DELTA);
end;
/