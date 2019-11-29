UNWIND ['1','2','3','4','5'] as book
LOAD CSV WITH HEADERS FROM 
'https://raw.githubusercontent.com/mathbeveridge/asoiaf/master/data/asoiaf-book' + book + '-edges.csv' as value
MERGE (source:Person{id:value.Source})
MERGE (target:Person{id:value.Target})
WITH source,target,value.weight as weight,book
CALL apoc.merge.relationship(source,'INTERACTS_' + book, {}, {weight:toFloat(weight)}, target) YIELD rel
RETURN distinct 'done';

UNWIND ['1','2','3','4','5'] as sequence
MERGE (book:Book{sequence:sequence})
WITH book,sequence
CALL algo.pageRank.stream(
 'MATCH (p:Person) WHERE (p)-[:INTERACTS_' + sequence + ']-() RETURN id(p) as id',
 'MATCH (p1:Person)-[INTERACTS_' + sequence + ']-(p2:Person) RETURN id(p1) as source,id(p2) as target',
 {graph:'cypher'})
YIELD nodeId,score
// filter out nodes with default pagerank 
// for nodes with no incoming rels
WITH nodeId,score,book where score > 0.16
MERGE (node)<-[p:PAGERANK]-(book)
SET p.score = score;