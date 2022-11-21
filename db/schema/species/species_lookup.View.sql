create or replace view species_lookup as
select
  s.id,
  s.name,
  p.name as planet_name,
  b.name as behaviour,
  sc.name as sentience
from species s
  inner join sentience_classes sc on s.sentience_id = sc.id
  inner join behaviours b on s.behaviour_id = b.id
  inner join species_occurences so on s.id = so.species_id
  inner join planets p on so.planet_id = p.id
;