CREATE CONSTRAINT ON (s:Station) ASSERT s.id is unique;
CREATE INDEX ON :Station(name);

LOAD CSV WITH HEADERS FROM
"https://raw.githubusercontent.com/nicola/tubemaps/master/datasets/london.stations.csv" as row
MERGE (s:Station{id:row.id})
ON CREATE SET s.name = row.name,
              s.latitude=row.latitude,
              s.longitude=row.longitude,
              s.zone=row.zone,
              s.total_lines=row.total_lines;

LOAD CSV WITH HEADERS FROM
"https://raw.githubusercontent.com/nicola/tubemaps/master/datasets/london.connections.csv" as row
MATCH (s1:Station{id:row.station1})
MATCH (s2:Station{id:row.station2})
MERGE (s1)-[:CONNECTION{time:row.time,line:row.line}]->(s2)
MERGE (s1)<-[:CONNECTION{time:row.time,line:row.line}]-(s2);