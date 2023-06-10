-- ===================================
-- Order Priority Checking Query (Q4)
-- ===================================

set serveroutput on

var D char(10)
declare
    type year_month_names_type is varray(58)
        of char(7);
    ym_names year_month_names_type := year_month_names_type();
    y integer;
    m integer;
begin
    for y in 1993..1997 loop
        for m in 1..12 loop
            if not (y = 1997 and m > 10) then
                ym_names.extend;
                if m < 10 then
                   ym_names(ym_names.last) := to_char(y) || '-0' || to_char(m);
                else 
                    ym_names(ym_names.last) := to_char(y) || '-' || to_char(m);
                end if;
            end if;
        end loop;
    end loop;
    :D := ym_names(trunc(dbms_random.value(1, ym_names.count + 1), 0)) || '-01';
    dbms_output.put_line('Date=' || :D);
end;
/

select
    o_orderpriority
    ,count(o_orderkey) as order_count
from orders
where 
    1 = 1
    and  o_orderdate >= to_date(:D, 'YYYY-MM-DD')
    and o_orderdate < add_months(to_date(:D, 'YYYY-MM-DD'), 3)
    and exists (select *
                from lineitem
                where 
                    l_orderkey = o_orderkey
                    and l_commitdate < l_receiptdate
                )
group by 
    o_orderpriority
order by
    o_orderpriority
;

begin
    dbms_output.put_line('Query is executed with:');
    dbms_output.put_line('DATE=' || :D);
end;
/
