create or replace view species_data as
select
  s.id,
  s.name,
  json_serialize (
    json_array(
      json_object(
        s.uuid,
        s.name,
        'behaviour' value b.name,
        'sentience' value sc.name,
        'planets' value json_arrayagg(
          p.name
          order by p.name
        )
      )
    )
    pretty
  ) json_data
from species s
  inner join sentience_classes sc on s.sentience_id = sc.id
  inner join behaviours b on s.behaviour_id = b.id
  inner join species_occurences so on s.id = so.species_id
  inner join planets p on so.planet_id = p.id
group by s.id, s.uuid, s.name, b.name, sc.name
;