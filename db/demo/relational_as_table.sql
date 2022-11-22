select
  s.uuid uuid,
  s.name name,
  b.name behaviour,
  sc.name sentience,
  p.name planet
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
    );
