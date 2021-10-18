CREATE INDEX ON :City(city_uri);

LOAD CSV WITH HEADERS FROM "file:///cities.csv" AS row
MERGE (cty:City {city_uri: row.city}) 
      SET cty.city_pop= coalesce(row.pop,0), cty.city_name = row.cityName
MERGE (ctr:Country {ctry_uri: row.ctr}) 
      SET ctr.ctry_name = row.ctrName
MERGE (pty:Party {party_uri: row.party})
MERGE (cty)-[:CTY_IN_COUNTRY]->(ctr)
MERGE (cty)-[:GOVERNING_PARTY]->(pty);

LOAD CSV WITH HEADERS FROM "file:///parties.csv" AS row
MERGE (pty:Party {party_uri: row.party}) 
      SET pty.party_name = row.partyName
MERGE (ide:Ideology {ideology_uri: row.ideology}) 
      SET ide.ideology_name = row.ideologyName
MERGE (pty)-[:HAS_IDEOLOGY]->(ide);