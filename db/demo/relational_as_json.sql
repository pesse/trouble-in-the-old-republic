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
    --where search_p.name = 'Coruscant'
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