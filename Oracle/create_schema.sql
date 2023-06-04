create user tpc_h identified by tpc_h;

alter user tpc_h default tablespace users;
alter user tpc_h quota unlimited on users;
alter user tpc_h temporary tablespace temp;

grant create session, create table, create view to tpc_h;
grant alter session to tpc_h;

---