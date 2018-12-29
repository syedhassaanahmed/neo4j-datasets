CREATE INDEX ON :Author(name);
CREATE INDEX ON :Book(id);
CREATE INDEX ON :Genre(name);

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/jbarrasa/datasets/master/goodreads/booklist.csv" AS row
MERGE (b:Book { id : row.itemUrl})
SET b.description = row.description, b.title = row.itemTitle
WITH b, row
UNWIND split(row.genres,';') AS genre
MERGE (g:Genre { name: substring(genre,8)})
MERGE (b)-[:HAS_GENRE]->(g)
WITH b, row
UNWIND split(row.author,';') AS author
MERGE (a:Author { name: author})
MERGE (b)-[:HAS_AUTHOR]->(a);

MATCH (g:Genre) WHERE SIZE((g)<-[:HAS_GENRE]-()) > 5 //Threshold 
WITH g, size((g)<-[:HAS_GENRE]-()) as totalCount
MATCH (g)<-[:HAS_GENRE]-(book)-[:HAS_GENRE]->(relatedGenre)
WITH g, relatedGenre, toFloat(count(book)) / totalCount AS coocIndex
CREATE (g)-[:CO_OCCURS {index: coocIndex }]->(relatedGenre);

MATCH (g1)-[co1:CO_OCCURS {index : 1}]->(g2),
      (g2)-[co2:CO_OCCURS { index: 1}]->(g1)
WHERE ID(g1) > ID(g2)
MERGE (g1)-[:SAME_AS]-(g2);

MATCH (g1)-[co1:CO_OCCURS]->(g2), 
      (g2)-[co2:CO_OCCURS]->(g1)
WHERE ID(g1) > ID(g2) 
      AND co1.index = 1 and co2.index < 1 MERGE (g1)-[:NARROWER_THAN]->(g2);

MATCH (g1)-[:NARROWER_THAN*2..]->(g3), 
      (g1)-[d:NARROWER_THAN]->(g3)
DELETE d;