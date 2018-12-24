LOAD CSV WITH HEADERS FROM 
"https://www.macalester.edu/~abeverid/data/stormofswords.csv" AS row
MERGE (src:Character {name: row.Source})
MERGE (tgt:Character {name: row.Target})
MERGE (src)-[r:INTERACTS]->(tgt)
ON CREATE SET r.weight = toInt(row.Weight);

CALL algo.triangleCount('Character', 'INTERACTS',
{write:true, writeProperty:'triangles',clusteringCoefficientProperty:'coefficient'}) 
YIELD nodeCount, triangleCount, averageClusteringCoefficient;

CALL algo.pageRank(
 'MATCH (c:Character) RETURN id(c) as id',
 'MATCH (p1:Character)-[:INTERACTS]-(p2:Character) 
  RETURN id(p1) as source, id(p2) as target',
{graph:'cypher'});

CALL algo.closeness.harmonic(
  'MATCH (c:Character) RETURN id(c) as id',
  'MATCH (c1:Character)-[:INTERACTS]-(c2:Character) 
   RETURN id(c1) as source, id(c2) as target',
{graph:'cypher', writeProperty: 'harmonic'});

WITH ["pagerank","harmonic","triangles"] as keys
UNWIND keys as key
MATCH (c:Character)
WITH max(c[key]) as max,min(c[key]) as min,key
MATCH (c1:Character)
WITH c1, key + "normalized" AS newKey, 
    (toFloat(c1[key]) - min) / (max - min) as normalized_value
CALL apoc.create.setProperty(c1, newKey, normalized_value) 
YIELD node
RETURN COUNT(*);

MATCH (c1:Character),(c2:Character) where id(c1) < id(c2)
WITH c1,c2,apoc.algo.cosineSimilarity([c1.pageranknormalized,
                                       c1.coefficient,
                                       c1.harmonicnormalized,
                                       c1.trianglesnormalized],
                                      [c2.pageranknormalized,
                                       c2.coefficient,
                                       c2.harmonicnormalized,
                                       c2.trianglesnormalized]) 
                                         as cosine_similarity
WHERE cosine_similarity > 0.9
MERGE (c1)-[s:SIMILAR_POSITION]-(c2)
SET s.cosine = cosine_similarity;