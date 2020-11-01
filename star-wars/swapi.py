from py2neo import Graph
import requests
import os

graph = Graph("bolt://localhost:7687", auth=(os.environ["NEO4J_USERNAME"], os.environ["NEO4J_PASSWORD"]))

graph.run("CREATE CONSTRAINT ON (f:Film) ASSERT f.url IS UNIQUE")
graph.run("CREATE CONSTRAINT ON (p:Person) ASSERT p.url IS UNIQUE")
graph.run("CREATE CONSTRAINT ON (v:Vehicle) ASSERT v.url IS UNIQUE")
graph.run("CREATE CONSTRAINT ON (s:Starship) ASSERT s.url IS UNIQUE")
graph.run("CREATE CONSTRAINT ON (p:Planet) ASSERT p.url IS UNIQUE")

CREATE_PERSON_QUERY = '''
MERGE (p:Person {url: $url})
SET p.birth_year = $birth_year,
    p.created = $created,
    p.edited = $edited,
    p.eye_color = $eye_color,
    p.gender = $gender,
    p.hair_color = $hair_color,
    p.height = $height,
    p.mass = $mass,
    p.name = $name,
    p.skin_color = $skin_color
REMOVE p:Placeholder
WITH p
MERGE (home:Planet {url: $homeworld})
ON CREATE SET home:Placeholder
MERGE (home)<-[:IS_FROM]-(p)
WITH p
UNWIND $species AS specie
MERGE (s:Species {url: specie})
ON CREATE SET s:Placeholder
MERGE (p)-[:IS_SPECIES]->(s)
WITH DISTINCT p
UNWIND $starships AS starship
MERGE (s:Starship {url: starship})
ON CREATE SET s:Placeholder
MERGE (p)-[:PILOTS]->(s)
WITH DISTINCT p
UNWIND $vehicles AS vehicle
MERGE (v:Vehicle {url: vehicle})
ON CREATE SET v:Placeholder
MERGE (p)-[:PILOTS]->(v)
'''

CREATE_MOVIE_QUERY = '''
MERGE (f:Film {url: $url})
SET f.created = $created,
    f.edited = $edited,
    f.episode_id = toInteger($episode_id),
    f.opening_crawl = $opening_crawl,
    f.release_date = $release_date,
    f.title = $title
WITH f
UNWIND split($director, ",") AS director
MERGE (d:Director {name: director})
MERGE (f)-[:DIRECTED_BY]->(d)
WITH DISTINCT f
UNWIND split($producer, ",") AS producer
MERGE (p:Producer {name: producer})
MERGE (f)-[:PRODUCED_BY]->(p)
WITH DISTINCT f
UNWIND $characters AS character
MERGE (c:Person {url: character})
ON CREATE SET c:Placeholder
MERGE (c)-[:APPEARS_IN]->(f)
WITH DISTINCT f
UNWIND $planets AS planet
MERGE (p:Planet {url: planet})
ON CREATE SET p:Placeholder
MERGE (f)-[:TAKES_PLACE_ON]->(p)
WITH DISTINCT f
UNWIND $species AS specie
MERGE (s:Species {url: specie})
ON CREATE SET s:Placeholder
MERGE (s)-[:APPEARS_IN]->(f)
WITH DISTINCT f
UNWIND $starships AS starship
MERGE (s:Starship {url: starship})
ON CREATE SET s:Placeholder
MERGE (s)-[:APPEARS_IN]->(f)
WITH DISTINCT f
UNWIND $vehicles AS vehicle
MERGE (v:Vehicle {url: vehicle})
ON CREATE SET v:Placeholder
MERGE (v)-[:APPEARS_IN]->(f)
'''

CREATE_PLANET_QUERY = '''
MERGE (p:Planet {url: $url})
SET p.created = $created,
    p.diameter = $diameter,
    p.edited = $edited,
    p.gravity = $gravity,
    p.name = $name,
    p.orbital_period = $orbital_period,
    p.population = $population,
    p.rotation_period = $rotation_period,
    p.surface_water = $surface_water
REMOVE p:Placeholder
WITH p
UNWIND split($climate, ",") AS c
MERGE (cli:Climate {type: c})
MERGE (p)-[:HAS_CLIMATE]->(cli)
WITH DISTINCT p
UNWIND split($terrain, ",") AS t
MERGE (ter:Terrain {type: t})
MERGE (p)-[:HAS_TERRAIN]->(ter)
'''

CREATE_SPECIES_QUERY = '''
MERGE (s:Species {url: $url})
SET s.name = $name,
    s.language = $language,
    s.average_height = $average_height,
    s.average_lifespan = $average_lifespan,
    s.classification = $classification,
    s.created = $created,
    s.designation = $designation,
    s.eye_colors = $eye_colors,
    s.hair_colors = $hair_colors,
    s.skin_colors = $skin_colors
REMOVE s:Placeholder
'''

CREATE_STARSHIP_QUERY = '''
MERGE (s:Starship {url: $url})
SET s.MGLT = $MGLT,
    s.consumables = $consumables,
    s.cost_in_credits = $cost_in_credits,
    s.created = $created,
    s.crew = $crew,
    s.edited = $edited,
    s.hyperdrive_rating = $hyperdrive_rating,
    s.length = $length,
    s.max_atmosphering_speed = $max_atmosphering_speed,
    s.model = $model,
    s.name = $name,
    s.passengers = $passengers
REMOVE s:Placeholder
MERGE (m:Manufacturer {name: $manufacturer})
MERGE (s)-[:MANUFACTURED_BY]->(m)
WITH s
MERGE (c:StarshipClass {type: $starship_class})
MERGE (s)-[:IS_CLASS]->(c)
'''

CREATE_VEHICLE_QUERY = '''
MERGE (v:Vehicle {url: $url})
SET v.cargo_capacity = $cargo_capacity,
    v.consumables = $consumables,
    v.cost_in_credits = $cost_in_credits,
    v.created = $created,
    v.crew = $crew,
    v.edited = $edited,
    v.length = $length,
    v.max_atmosphering_speed = $max_atmosphering_speed,
    v.model = $model,
    v.name = $name,
    v.passengers = $passengers
REMOVE v:Placeholder
MERGE (m:Manufacturer {name: $manufacturer})
MERGE (v)-[:MANUFACTURED_BY]->(m)
WITH v
MERGE (c:VehicleClass {type: $vehicle_class})
MERGE (v)-[:IS_CLASS]->(c)
'''

for i in range(1,7):
    url = "https://swapi.dev/api/films/" + str(i) + "/"
    r = requests.get(url)
    params = r.json()
    graph.run(CREATE_MOVIE_QUERY, params)
    print("Inserted film: " + str(url))

FIND_NEW_ENTITY_QUERY = '''
MATCH (p:Placeholder)
WITH rand() AS r, p ORDER BY r LIMIT 1
WITH p
RETURN p.url AS url, CASE WHEN head(labels(p))="Placeholder" THEN labels(p)[1] ELSE head(labels(p)) END AS type
'''

def getQueryForLabel(label):
    if (label == 'Vehicle'):
        return CREATE_VEHICLE_QUERY
    elif (label == 'Species'):
        return CREATE_SPECIES_QUERY
    elif (label == 'Person'):
        return CREATE_PERSON_QUERY
    elif (label == 'Starship'):
        return CREATE_STARSHIP_QUERY
    elif (label == 'Planet'):
        return CREATE_PLANET_QUERY
    else:
        raise ValueError("Unknown label for entity: " + str(label))

result = graph.run(FIND_NEW_ENTITY_QUERY)
while result.forward():
    label = result.current["type"]
    url = result.current["url"]
    r = requests.get(url)
    params = r.json()
    graph.run(getQueryForLabel(label), params)
    result = graph.run(FIND_NEW_ENTITY_QUERY)