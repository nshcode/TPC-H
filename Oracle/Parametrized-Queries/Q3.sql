-- =============================
-- Shipping Priority Query (Q3)
-- =============================
set serveroutput on

var S char(10 char);
var D number;
declare 
    type segment_names_type is varray(5) 
        of char(10 char) not null;
    s_names segment_names_type := segment_names_type('AUTOMOBILE'
                                                     ,'BUILDING'
                                                     ,'FURNITURE'
                                                     ,'MACHINERY'
                                                     ,'HOUSEHOLD');
    d1 date;            
begin
    :S := s_names(trunc(dbms_random.value(1, s_names.count + 1), 0));
    :D := trunc(dbms_random.value(1, 31), 0);
    d1 := to_date('1995-03-1', 'YYYY-MM-DD') + :D;
    dbms_output.put_line('SEGMENT=' || :S);
    dbms_output.put_line('DATE=' || to_char(d1, 'YYYY-MM-DD'));
end;
/

select 
    o_orderkey
    ,o_orderdate
    ,o_shippriority
    ,sum(l_extendedprice * (1 - l_discount)) as revenue
from 
    customer
    ,orders
    ,lineitem 
where 
    1 = 1
    and c_custkey = o_custkey
    and o_orderkey = l_orderkey
    and c_mktsegment = :S
    and o_orderdate < to_date('1995-03-15', 'YYYY-MM-DD')
    and l_shipdate > to_date('1995-03-1', 'YYYY-MM-DD') + :D
group by
    o_orderkey
    ,o_orderdate
    ,o_shippriority
order by 
    revenue desc
    ,o_orderdate
fetch first 10 row only;

declare 
    d1 date;
begin
    dbms_output.put_line('Query is executed with:');
    dbms_output.put_line('SEGMENT='   || :S);
    d1 := to_date('1995-03-1', 'YYYY-MM-DD') + :D;
    dbms_output.put_line('DATE=' || to_char(d1, 'YYYY-MM-DD'));
end;
/