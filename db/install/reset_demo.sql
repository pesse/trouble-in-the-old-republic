--@../schema/utils/utl_db_object.pks
--@../schema/utils/utl_db_object.pkb

call utl_db_object.drop_if_exists('SPECIES_OCCURENCES', 'TABLE');
call utl_db_object.drop_if_exists('SPECIES', 'TABLE');
call utl_db_object.drop_if_exists('SPECIES_RELATIONAL', 'TABLE');
call utl_db_object.drop_if_exists('PLANETS', 'TABLE');
call utl_db_object.drop_if_exists('BEHAVIOURS', 'TABLE');
call utl_db_object.drop_if_exists('SENTIENCE_CLASSES', 'TABLE');

create table planets (
  id integer generated by default as identity primary key,
  name varchar2(100) not null unique
);

insert into planets ( id, name ) values ( 1, 'Endor');
insert into planets ( id, name ) values ( 2, 'Coruscant');
insert into planets ( id, name ) values ( 3, 'Tatooine');

create table behaviours (
  id integer generated by default as identity primary key,
  name varchar2(100) unique
);

insert into behaviours (id, name) values (1, 'aggressive');
insert into behaviours (id, name) values (2, 'peaceful');
insert into behaviours (id, name) values (3, 'passive');
insert into behaviours (id, name) values (4, 'nonviolent');

create table sentience_classes (
  id integer generated by default as identity primary key,
  name varchar2(100) unique
);

insert into sentience_classes (id, name) values (1, 'sentient');
insert into sentience_classes (id, name) values (2, 'semi-sentient');
insert into sentience_classes (id, name) values (3, 'non-sentient');

create table species (
  id integer generated by default as identity primary key,
  name varchar2(2000) not null unique,
  data clob
);

insert into species ( id, name, data ) values ( 1, 'Ewok', '{
    "uuid" : "EB7858D7C791011EE053020011AC2D3E",
    "name" : "Ewok",
    "behaviour" : "peaceful",
    "sentience" : "sentient",
    "planets" :
    [
      "Endor"
    ]
  }' );
insert into species ( id, name, data ) values ( 2, 'Human', '{
    "uuid" : "EB7858D7C792011EE053020011AC2D3E",
    "name" : "Human",
    "behaviour" : "aggressive",
    "sentience" : "sentient",
    "planets" :
    [
      "Coruscant",
      "Endor",
      "Tatooine"
    ]
  }' );

select * from species;

create table species_relational (
  id integer generated by default as identity primary key,
  uuid varchar2(36) default on null sys_guid() not null unique,
  name varchar2(2000) not null unique,
  behaviour_id integer
    references behaviours ( id ) on delete set null,
  sentience_id integer
    references sentience_classes ( id ) on delete set null,
  created timestamp default on null systimestamp,
  last_modified timestamp
);


insert into species_relational ( id, name, behaviour_id, sentience_id ) values ( 1, 'Ewok', 2, 1 );
insert into species_relational ( id, name, behaviour_id, sentience_id ) values ( 2, 'Human', 1, 1 );

select * from species_relational;

create table species_occurences (
  species_id integer not null,
  planet_id integer not null,
  first_documented timestamp with local time zone default on null current_timestamp,
  primary key (species_id, planet_id)
);

insert into species_occurences ( species_id, planet_id ) values (1, 1);
insert into species_occurences ( species_id, planet_id ) values (2, 2);
insert into species_occurences ( species_id, planet_id ) values (2, 3);
insert into species_occurences ( species_id, planet_id ) values (2, 1);

commit;