CALL apoc.import.graphml('https://raw.githubusercontent.com/krlawrence/graph/master/sample-data/air-routes.graphml', {batchSize: 10000, readLabels: true, storeNodeIds: true});

MATCH (n) WHERE size(labels(n)) = 0 and n.labelV = 'airport' SET n:airport;
MATCH (n) WHERE size(labels(n)) = 0 and n.labelV = 'country' SET n:country;
MATCH (n) WHERE size(labels(n)) = 0 and n.labelV = 'continent' SET n:continent;
MATCH (n) WHERE size(labels(n)) = 0 and n.labelV = 'version' SET n:version;

MATCH (a)-[r:RELATED]->(b) where r.labelE = 'route' CREATE (a)-[r2:route]->(b) SET r2 = r WITH r DELETE r;
MATCH (a)-[r:RELATED]->(b) where r.labelE = 'contains' CREATE (a)-[r2:contains]->(b) SET r2 = r WITH r DELETE r;