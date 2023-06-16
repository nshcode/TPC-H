
set serveroutput on

var O_KEY number
var L_KEY number
var DELTA number
declare 
    m number(38);
begin
    select
        x.o_orderkey
    into 
        :O_KEY
    from 
    (
        select 
            o.o_orderkey
            ,rownum rn
        from orders o
    ) x
    where x.rn in (select trunc(dbms_random.value(1, (select count(*) + 1 from orders)), 0) 
                    from dual
                );
    
    select
        max(l_linenumber)
    into m
    from lineitem
    where l_orderkey = :O_KEY;
    :L_KEY := trunc(dbms_random.value(1, m + 1));
    
    :DELTA :=  trunc(dbms_random.value(1, 100 + 1));
end;
/

var QUANTITY number
var EXTPRICE number
var OTOTAL   number
var RPRICE   number
var PKEY     number
var SKEY     number
var TAX      number
var DISC     number
declare
    pkey         number(38);
    skey         number(38);
    cost         number(38, 2);
    new_extprice number(38, 2);
    new_ototal   number(38, 2);
    current_d_ts timestamp;
begin
    select o_totalprice 
    into :OTOTAL
    from orders
    where o_orderkey = :O_KEY
    ;
    
    select
        l_quantity
        ,l_extendedprice
        ,l_partkey
        ,l_suppkey
        ,l_tax
        ,l_discount
    into
        :QUANTITY
        ,:EXTPRICE
        ,pkey
        ,skey
        ,:TAX
        ,:DISC
    from lineitem
    where 1 = 1
        and l_orderkey   = :O_KEY
        and l_linenumber = :L_KEY
    ;
    
    :OTOTAL      := :OTOTAL - trunc(trunc(:EXTPRICE * (1 - :DISC), 2) * (1 + :TAX), 2);
    :RPRICE      := trunc(:EXTPRICE / :QUANTITY, 2);
    cost         := trunc(:RPRICE * :DELTA, 2);
    new_extprice := :EXTPRICE + cost;
    new_ototal   := trunc(new_extprice * (1.0 - :DISC) ,2);
    new_ototal   := trunc(new_ototal * (1.0 + :TAX), 2);
    new_ototal   := :OTOTAL + new_ototal;
    
    execute immediate
        'update 
            lineitem
        set 
            l_extendedprice = :1
            ,l_quantity     = :2
        where 1 = 1
            and l_orderkey   = :3
            and l_linenumber = :4'
    using 
        new_extprice
        , :QUANTITY + :DELTA
        , :O_KEY
        , :L_KEY
    ;
    
    execute immediate
        'update
            orders
        set 
            o_totalprice = :1
        where 
            o_orderkey = :2'
    using 
        new_ototal
        , :O_KEY
    ;
    
    select current_timestamp(0) into current_d_ts from dual;
    execute immediate
        'insert into tpch_history (
                                h_p_key
                                ,h_s_key
                                ,h_o_key
                                ,h_l_key
                                ,h_delta 
                                ,h_date_t
                                ) 
                        values (
                                :1
                                , :2
                                , :3
                                , :4
                                , :5
                                , :6
                            )' 
    using 
        pkey
        , skey
        , :O_KEY
        , :L_KEY
        , :DELTA
        , current_d_ts
    ;
end;
/

begin
    dbms_output.put_line('O_KEY=' || :O_KEY);
    dbms_output.put_line('L_KEY=' || :L_KEY);
    dbms_output.put_line('DELTA=' || :DELTA);
    dbms_output.put_line('');
    dbms_output.put_line('OTOTAL='   || :OTOTAL);
    dbms_output.put_line('RPRICE='   || :RPRICE);
    dbms_output.put_line('QUANTITY=' || :QUANTITY);
    dbms_output.put_line('EXRPRICE=' || :EXTPRICE);
    dbms_output.put_line('DISC='     || :DISC);
    dbms_output.put_line('TAX='      || :TAX);
end;
/

-- ================
-- Atomicity Tests
-- ================
declare
    actual_new_extprice     number(38, 2);
    actual_new_ototal       number(38, 2);
    actual_new_l_quantity   number(38, 2);
    expected_new_extprice   number(38, 2);
    expected_new_ototal     number(38, 2);
    expected_new_l_quantity number(38, 2);
begin
    select 
        l_extendedprice
        ,l_quantity
    into
        actual_new_extprice,
        actual_new_l_quantity
    from 
        lineitem
    where 1 = 1
        and l_orderkey =   :O_KEY
        and l_linenumber = :L_KEY
    ;
    expected_new_l_quantity := :QUANTITY + :DELTA;
    expected_new_extprice   := :EXTPRICE + trunc(:RPRICE * :DELTA, 2);
    
    select
        o_totalprice
    into 
        actual_new_ototal
    from 
        orders
    where 
        o_orderkey = :O_KEY
    ;
    expected_new_ototal := trunc(expected_new_extprice * (1.0 - :DISC), 2);
    expected_new_ototal := trunc(expected_new_ototal * (1.0 + :TAX), 2);
    expected_new_ototal := expected_new_ototal + :OTOTAL;
    
    if actual_new_extprice = expected_new_extprice then
        dbms_output.put_line('NEW_EXTPRICE is OK');
    else 
        dbms_output.put_line('NEW_EXTPRICE is NOT OK. ' 
                            || '(Expected: ' || expected_new_extprice 
                            || ', Actual: '  ||  actual_new_extprice || ')');
    end if;
    if actual_new_l_quantity = expected_new_l_quantity then
        dbms_output.put_line('NEW_L_QUANTITY is OK');
    else 
        dbms_output.put_line('NEW_L_QUANTITY is NOT OK. ' 
                            || '(Expected: ' || expected_new_l_quantity 
                            || ', Actual: '  ||  actual_new_l_quantity || ')');
    end if;
    if  expected_new_ototal = expected_new_ototal then
        dbms_output.put_line('NEW_TOTAL is OK');
    else 
        dbms_output.put_line('NEW_TOTAL is NOT OK. ' 
                            || '(Expected: ' ||  expected_new_ototal
                            || ', Actual: '  ||  actual_new_ototal || ')');
    end if;
end;
/

