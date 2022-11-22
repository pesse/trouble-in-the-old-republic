-- All the Species as complete JSON stream
select
  json_serialize(
    json_arrayagg(
      json_object(
        s.uuid,
        s.name,
        'behaviour' value b.name,
        'sentience' value sc.name,
        'planets' value
          (select
            json_arrayagg(p.name)
          from planets p
            inner join species_occurences so on p.id = so.planet_id
          where so.species_id = s.id
          )
        )
      )
      pretty
    )
    json_data
from species_relational s
  inner join sentience_classes sc on s.sentience_id = sc.id
  inner join behaviours b on s.behaviour_id = b.id
;

-- All the species' JSON grouped by the specific lifeform
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
from species_relational s
  inner join sentience_classes sc on s.sentience_id = sc.id
  inner join behaviours b on s.behaviour_id = b.id
  inner join species_occurences so on s.id = so.species_id
  inner join planets p on so.planet_id = p.id
group by s.id, s.uuid, s.name, b.name, sc.name;
;


-- All the species' JSON that are found on a specific planet
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
from species_relational s
  inner join sentience_classes sc on s.sentience_id = sc.id
  inner join behaviours b on s.behaviour_id = b.id
  inner join species_occurences so on s.id = so.species_id
  inner join planets p on so.planet_id = p.id
where
  s.id in (
    select search_s.id
    from species_relational search_s
      inner join species_occurences search_so on search_s.id = search_so.species_id
      inner join planets search_p on search_so.planet_id = search_p.id
    where search_p.name = 'Endor'
    )
group by s.id, s.uuid, s.name, b.name, sc.name;
;

-- Search + Delivery with views
select * from species_data sd
where sd.id in (
  select sl.id
  from species_lookup sl
  where sl.planet_name like '%ruscant%'
);


select
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
group by s.id, s.uuid, s.name, b.name, sc.name;
;