-- ================================
-- Minimum Cost Supplier Query (Q2)
-- ================================

set serveroutput on;

var R char(15 char);
var T varchar2(25 char);
var S number;
declare
    type region_names_type is varray(5) 
        of char(15 char) not null;
    type lable_names_type is varray(5)
        of varchar2(25 char) not null;
    r_names region_names_type := region_names_type ('AFRICA'
                                                    ,'AMERICA'
                                                    ,'ASIA'
                                                    ,'EUROPE'     
                                                    ,'MIDDLE EAST');
    l_names lable_names_type := lable_names_type ('%TIN'
                                                  ,'%NICKEL'
                                                  ,'%BRASS'
                                                  ,'%STEEL'
                                                  ,'%COPPER');
begin
    :R := r_names(trunc(dbms_random.value(1, r_names.count + 1), 0));
    :T := l_names(trunc(dbms_random.value(1, l_names.count + 1), 0));
    :S := trunc(dbms_random.value(1, 51), 0);
    dbms_output.put_line('SIZE='   || :S);
    dbms_output.put_line('TYPE='   || :T);
    dbms_output.put_line('REGION=' || :R);
end;
/

select
    s_acctbal
    ,s_name
    ,n_name
    ,p_partkey
    ,p_mfgr
    ,s_address
    ,s_phone
    ,s_comment
    ,min(ps_supplycost) over (partition by p_type) min
    ,max(ps_supplycost) over (partition by p_type) max
    ,p_type
from 
    supplier
    ,partsupp
    ,part
    ,nation
    ,region
where 1 = 1
    and s_suppkey = ps_suppkey
    and p_partkey = ps_partkey
    and n_nationkey = s_nationkey
    and r_regionkey = n_regionkey
    and r_name = :R 
    and p_type like :T
    and p_size = :S
    and ps_supplycost = (select min (ps_supplycost) 
                        from supplier
                        join partsupp
                            on s_suppkey = ps_suppkey
                        join nation
                            on n_nationkey = s_nationkey
                        join region
                            on r_regionkey = n_regionkey
                        where r_name = :R
                            and p_partkey = ps_partkey)
order by
    p_type
    ,s_acctbal desc 
fetch first 100 row only
;

begin
    dbms_output.put_line('Query is executed with:');
    dbms_output.put_line('SIZE='   || :S);
    dbms_output.put_line('TYPE='   || :T);
    dbms_output.put_line('REGION=' || :R);
end;
/