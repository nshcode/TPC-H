-- =================================
-- Local Supplier Volume Query (Q5)
-- ================================

set serveroutput on

var R char(25 char);
var Y number;
declare
    type region_names_type is varray(5) 
        of char(25 char) not null;
    r_names region_names_type := region_names_type ('AFRICA'
                                                    ,'AMERICA'
                                                    ,'ASIA'
                                                    ,'EUROPE'     
                                                    ,'MIDDLE EAST');
begin
    :R := r_names(trunc(dbms_random.value(1, r_names.count + 1), 0));
    :Y := trunc(dbms_random.value(1993, 1998),0);
    dbms_output.put_line('REGION=' || :R);
    dbms_output.put_line('YEAR='   || :Y);
end;
/

select
    n_name
    ,sum(l_extendedprice * (1 - l_discount)) as revenue
from 
    customer
    ,orders
    ,lineitem
    ,supplier
    ,nation
    ,region
where 
    1 = 1
    and c_custkey = o_custkey
    and l_orderkey = o_orderkey
    and l_suppkey = s_suppkey
    and c_nationkey = s_nationkey
    and s_nationkey = n_nationkey
    and n_regionkey = r_regionkey
    and r_name = :R
    and o_orderdate >= to_date(to_char(:Y) || '-01-01','YYYY-MM-DD')
    and o_orderdate < to_date(to_char(:Y) || '-01-01', 'YYYY-MM-DD') + interval '1-0' year to month
group by 
    n_name
order by
    revenue desc
;

begin
    dbms_output.put_line('Query is executed with:');
    dbms_output.put_line('REGION=' || :R);
    dbms_output.put_line('YEAR='   || to_char(:Y));
end;
/