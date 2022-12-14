-- run once as SYS
create user genso
  identified by genso
  default tablespace users
  quota unlimited on users;

grant
  create session,
  create sequence,
  create procedure,
  create type,
  create table,
  create view,
  create synonym,
  create trigger
to genso;

grant alter session to genso;