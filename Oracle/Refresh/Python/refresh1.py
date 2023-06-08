import cx_Oracle
import config
from datetime import datetime
import os

cx_Oracle.init_oracle_client(lib_dir=r"path/to/orcale_client_library")


def insert_order(order, cursor):

    sql_template = ('insert into orders ('
                                        'o_orderkey'
                                        ',o_custkey' 
                                        ',o_orderstatus'
                                        ',o_totalprice'
                                        ',o_orderdate'
                                        ',o_orderpriority'
                                        ',o_check'
                                        ',o_shippriority'
                                        ',o_comment'
                                        ') ' 
                                'values '
                                        '('
                                        ':o_orderkey'
                                        ',:o_custkey' 
                                        ',:o_orderstatus'
                                        ',:o_totalprice'
                                        ',to_date(:o_orderdate, \'YYYY-MM-DD\')'
                                        ',:o_orderpriority'
                                        ',:o_check'
                                        ',:o_shippriority'
                                        ',:o_comment'
                                       ')'
                    )
    print(sql_template)
    cursor.execute(sql_template, order)


def insert_lineitem(lineitems, cursor):

    sql_template = ('insert into lineitem ('
                                            'l_orderkey'
                                            ',l_partkey'  
                                            ',l_suppkey'
                                            ',l_linenumber'
                                            ',l_quantity'
                                            ',l_extendedprice'
                                            ',l_discount'
                                            ',l_tax'
                                            ',l_returnflag'
                                            ',l_linestatus'
                                            ',l_shipdate'
                                            ',l_commitdate'
                                            ',l_receiptdate'
                                            ',l_shipinstruct'
                                            ',l_shipmode'
                                            ',l_comment'
                                            ') '
                                    'values ' 
                                            '('
                                            ':l_orderkey'
                                            ',:l_partkey'  
                                            ',:l_suppkey'
                                            ',:l_linenumber'
                                            ',:l_quantity'
                                            ',:l_extendedprice'
                                            ',:l_discount'
                                            ',:l_tax'
                                            ',:l_returnflag'
                                            ',:l_linestatus'
                                            ',to_date(:l_shipdate, \'YYYY-MM-DD\')'
                                            ',to_date(:l_commitdate, \'YYYY-MM-DD\')'
                                            ',to_date(:l_receiptdate, \'YYYY-MM-DD\')'
                                            ',:l_shipinstruct'
                                            ',:l_shipmode'
                                            ',:l_comment'
                                            ')'
                    )
    cursor.executemany(sql_template, lineitems)


def print_order(order):
    print(order)

def print_items(items):
    for item in items:
        print(item)

def create_order(oline):
    order = []
    oline =  oline.split('|')
    for i in range(0, len(oline) - 1):
        if i in (0, 1, 7):
            order.append(int(oline[i]))
        elif i == 3:
            order.append(float(oline[i]))
        else:
            order.append(oline[i])
    return order


def create_lineitem(iline):
    item = []
    iline = iline.split('|')
    for i in range(0, len(iline) - 1):
        if i in (0, 1, 2, 3):
            item.append(int(iline[i]))
        elif i in (4, 5, 6, 7):
            item.append(float(iline[i]))
        else:
            item.append(iline[i])
    return item


def load_data(orders_file_name, lineitems_file_name, connection):
    ocount = 0
    icount = 0
    with connection.cursor() as cursor:
        with open(orders_file_name, 'rt') as orders:
            with open(lineitems_file_name, 'rt') as lineitems:
                previous_item = None
                while True:
                    oline = orders.readline()
                    if not oline:
                        break
                    order = create_order(oline)
                    items = []
                    while True:
                        iline = lineitems.readline()
                        if not iline:
                            break
                        if previous_item:
                            items.append(previous_item)
                            previous_item = None
                        item = create_lineitem(iline)
                        if order[0] == item[0]:
                            items.append(item)
                        else:
                            previous_item = item
                            break
                    #print('###########################################')
                    #print('#order=')
                    #print_order(order)
                    #print('#Items=' , len(items))
                    #print_items(items)
                    print('inserting ... ')
                    insert_order(order, cursor)
                    insert_lineitem(items, cursor)
            

def get_full_data_file_names():
    full_file_names = []
    data_dir = config.refresh_data_dir
    refresh_file_names = config.refresh_file_names
    for fn_pair in refresh_file_names:
        fn1 = os.path.join(data_dir, fn_pair[0])
        fn2 = os.path.join(data_dir, fn_pair[1])
        full_file_names.append((fn1, fn2))
    return full_file_names


try:    
    with cx_Oracle.connect(config.username,
                           config.password,
                           config.dsn) as connection: 
        data_files = get_full_data_file_names()
        for (orders_file, lineitems_file) in data_files:
            load_data(orders_file, lineitems_file, connection)
        connection.commit()
except cx_Oracle.Error as error:
    print(error)
