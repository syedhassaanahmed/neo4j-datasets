CALL apoc.schema.assert(
{},
{Comic:['name'],Hero:['name']});

USING PERIODIC COMMIT 5000
LOAD CSV WITH HEADERS FROM 
"https://raw.githubusercontent.com/tomasonjo/neo4j-marvel/master/data/edges.csv" as row
MERGE (h:Hero{name:row.hero})
MERGE (c:Comic{name:row.comic})
MERGE (h)-[:APPEARED_IN]->(c);

CALL apoc.periodic.iterate(
"MATCH (p1:Hero)-->(:Comic)<--(p2:Hero) where id(p1) < id(p2) RETURN p1,p2",
"MERGE (p1)-[r:KNOWS]-(p2) ON CREATE SET r.weight = 1 ON MATCH SET r.weight = r.weight + 1"
, {batchSize:5000, parallel:false,iterateList:true});