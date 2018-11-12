// Import Organization Relationships
CREATE CONSTRAINT ON (o:Organization) ASSERT o.name IS UNIQUE;

WITH
'https://docs.google.com/spreadsheets/u/1/d/1Z5Vo5pbvxKJ5XpfALZXvCzW26Cl4we3OaN73K9Ae5Ss/export?format=csv&gid=1996904412' AS url,
['LOAN','LOBBIED','SALE','SUPPLIER','SHAREHOLDER','LICENSES','AFFILIATED','TIES','NEGOTIATION','INVOLVED','PARTNER'] AS terms
LOAD CSV WITH HEADERS FROM url AS row

WITH terms, row WHERE row.`Entity A Type` = 'Organization' AND row.`Entity B Type` = 'Organization'
WITH apoc.text.regreplace(toUpper(row.Connection),'\\W+','_') AS type, row, terms
WITH coalesce(head(filter(term IN terms WHERE type CONTAINS term)), type) AS type, row

MERGE (o1:Organization {name:row.`Entity A`})
MERGE (o2:Organization {name:row.`Entity B`})
WITH o1,o2,type,row
CALL apoc.create.relationship(o1,type, {source:row.`Source(s)`, connection:row.Connection},o2) YIELD rel
RETURN type(rel), count(*)
ORDER BY count(*) DESC;

MATCH (o:Organization)
WHERE o.name CONTAINS "BANK" SET o:Bank;

MATCH (o:Organization)
WHERE o.name CONTAINS "HOTEL" SET o:Hotel;

MATCH (o:Organization)
WHERE any(term in ["TRUMP","DT","DJT"] WHERE o.name CONTAINS (term + " "))
SET o:Trump;

// Import Person Organization Relationships
CREATE CONSTRAINT ON (p:Person) ASSERT p.name IS UNIQUE;

WITH
'https://docs.google.com/spreadsheets/u/1/d/1Z5Vo5pbvxKJ5XpfALZXvCzW26Cl4we3OaN73K9Ae5Ss/export?format=csv&gid=1996904412' AS url,
['BOARD','DIRECTOR','INCOME','PRESIDENT','CHAIR','CEO','PARTNER','OWNER','INVESTOR','FOUNDER','STAFF','DEVELOPER','EXECUTIVE_COMITTEE','EXECUTIVE','FELLOW','BANKER','COUNSEL','ADVISOR','SHAREHOLDER','LIASON','SPEECH','CONNECTED','HIRED','CONSULTED','INVOLVED','APPOINTEE','MANAGER','TRUSTEE','AMBASSADOR','PUBLISHER','LAWYER'] AS terms
LOAD CSV WITH HEADERS FROM url AS row

WITH terms, row
WHERE row.`Entity A Type` = 'Person' AND row.`Entity B Type` = 'Organization'

WITH apoc.text.regreplace(toUpper(row.Connection),'\\W+','_') AS type, row, terms
WITH coalesce(head(filter(term IN terms WHERE type CONTAINS term)), 'INVOLVED_WITH') AS type, row

MERGE (p:Person {name:row.`Entity A`})
MERGE (o:Organization {name:row.`Entity B`})
WITH o,p,type,row
CALL apoc.create.relationship(p,type, {source:row.`Source(s)`, connection:row.Connection},o) YIELD rel
RETURN type(rel), count(*)
ORDER BY count(*) DESC;

WITH
'https://docs.google.com/spreadsheets/u/1/d/1Z5Vo5pbvxKJ5XpfALZXvCzW26Cl4we3OaN73K9Ae5Ss/export?format=csv&gid=1996904412' AS url,
['BOARD','DIRECTOR','INCOME','PRESIDENT','CHAIR','CEO','PARTNER','OWNER','INVESTOR','FOUNDER','STAFF','DEVELOPER','EXECUTIVE_COMITTEE','EXECUTIVE','FELLOW','BANKER','COUNSEL','ADVISOR','SHAREHOLDER','LIASON','SPEECH','CONNECTED','HIRED','CONSULTED','INVOLVED','APPOINTEE','MANAGER','TRUSTEE','AMBASSADOR','PUBLISHER','LAWYER'] AS terms
LOAD CSV WITH HEADERS FROM url AS row

WITH terms, row
WHERE row.`Entity A Type` = 'Organization' AND row.`Entity B Type` = 'Person'
WITH apoc.text.regreplace(toUpper(row.Connection),'\\W+','_') AS type, row, terms
WITH coalesce(head(filter(term IN terms WHERE type CONTAINS term)), 'INVOLVED_WITH') AS type, row

MERGE (o:Organization {name:row.`Entity A`})
MERGE (p:Person {name:row.`Entity B`})
WITH o,p,type,row
CALL apoc.create.relationship(p,type, {source:row.`Source(s)`, connection:row.Connection},o) YIELD rel
RETURN type(rel), count(*)
ORDER BY count(*) DESC;

// Import Person-Person Relationships
WITH
'https://docs.google.com/spreadsheets/u/1/d/1Z5Vo5pbvxKJ5XpfALZXvCzW26Cl4we3OaN73K9Ae5Ss/export?format=csv&gid=1996904412' AS url,
['WHITE_HOUSE','REPRESENTATIVE','FRIEND','DIRECTOR','ADVISOR','WORKED','MET','LUNCHED','NOMINEE','COUNSELOR','AIDED','CAMPAIGN','PARTNER','MARRIED','CLOSE','APPEARANCE','BOUGHT','SAT_IN','CONSULTED','CO_CHAIR','GAVE'] AS terms
LOAD CSV WITH HEADERS FROM url AS row
WITH terms, row
WHERE row.`Entity A Type` = 'Person' AND row.`Entity B Type` = 'Person'

WITH apoc.text.regreplace(toUpper(row.Connection),'\\W+','_') AS type, row, terms
WITH coalesce(head(filter(term IN terms WHERE type CONTAINS term)), type) AS type, row

MERGE (p1:Person {name:row.`Entity A`})
MERGE (p2:Person {name:row.`Entity B`})
WITH p1,p2,type,row
CALL apoc.create.relationship(p2,type, {source:row.`Source(s)`, connection:row.Connection},p1) YIELD rel
RETURN type(rel), count(*)
ORDER BY count(*) DESC;

// Extending The Data Model - LittleSis
WITH "https://raw.githubusercontent.com/johnymontana/neo4j-datasets/master/trumpworld/data/littlesis-trump-pers.csv" AS url
LOAD CSV WITH HEADERS FROM url AS row
WITH row WHERE row.relatedEntytyType = 'Org'
MATCH (p:Person { name : row.name })
MERGE (o:Organization { name : row.relatedEntityName })
ON CREATE SET o.source = 'LittleSis'
WITH p, o, row
CALL apoc.create.relationship(p,upper(row.reltype), {source:'LittleSis',reldesc : row.reldesc},o) YIELD rel
RETURN COUNT(rel);

WITH "https://raw.githubusercontent.com/johnymontana/neo4j-datasets/master/trumpworld/data/littlesis-trump-pers.csv" AS url
LOAD CSV WITH HEADERS FROM url AS row
WITH row WHERE row.relatedEntytyType = 'Person'
MATCH (p:Person { name : row.name })
MERGE (o:Person { name : row.relatedEntityName })
ON CREATE SET o.source = 'LittleSis'
WITH p, o, row
CALL apoc.create.relationship(p,upper(row.reltype), {source:'LittleSis',reldesc : row.reldesc},o) YIELD rel
RETURN COUNT(rel);

WITH "https://raw.githubusercontent.com/johnymontana/neo4j-datasets/master/trumpworld/data/littlesis-trump-org.csv" AS url
LOAD CSV WITH HEADERS FROM url AS row
WITH row WHERE row.relatedEntytyType = 'Person'
MATCH (p:Organization { name : row.name })
MERGE (o:Person { name : row.relatedEntityName })
ON CREATE SET o.source = 'LittleSis'
WITH p, o, row
CALL apoc.create.relationship(p,upper(row.reltype), {source:'LittleSis',reldesc : row.reldesc},o) YIELD rel
RETURN COUNT(rel);

WITH "https://raw.githubusercontent.com/johnymontana/neo4j-datasets/master/trumpworld/data/littlesis-trump-org.csv" AS url
LOAD CSV WITH HEADERS FROM url AS row
WITH row WHERE row.relatedEntytyType = 'Org'
MATCH (p:Organization { name : row.name })
MERGE (o:Organization { name : row.relatedEntityName })
ON CREATE SET o.source = 'LittleSis'
WITH p, o, row
CALL apoc.create.relationship(p,upper(row.reltype), {source:'LittleSis',reldesc : row.reldesc},o) YIELD rel
RETURN COUNT(rel);

// Key Administration Positions
LOAD CSV FROM "https://raw.githubusercontent.com/neo4j-contrib/trumpworld-graph/master/07-trump-nominees/trump-nominees-wapost.csv" AS row FIELDTERMINATOR "\t"
WITH replace(toUpper(row[0]),"-"," ") as agency,toUpper(row[1]) as status,toUpper(row[3]) as name,toUpper(row[4]) as position
WHERE NOT position contains "AMBASSADOR"
MERGE (p:Person {name:name}) SET p.status = status
MERGE (a:Agency {name:agency})
WITH *
CALL apoc.create.relationship(p,position,{status:status},a) YIELD rel
RETURN count(rel);

LOAD CSV FROM "https://raw.githubusercontent.com/neo4j-contrib/trumpworld-graph/master/07-trump-nominees/trump-nominees-wapost.csv" AS row FIELDTERMINATOR "\t"
WITH toUpper(row[0]) as agency,toUpper(row[1]) as status,toUpper(row[3]) as name,toUpper(row[4]) as position
WHERE position contains "AMBASSADOR"
WITH *, split(position,", ")[1] as country
MERGE (p:Person {name:name}) SET p.status = status
MERGE (c:Country {name:country})
MERGE (p)-[r:AMBASSADOR]->(c) SET r.status = status;