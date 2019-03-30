// Create one node per motion
LOAD CSV WITH HEADERS FROM "https://github.com/mneedham/graphing-brexit/raw/master/data/motions.csv" AS row
MERGE (m:Motion {id: toInteger(row.id)})
SET m.name = row.name;

// Create nodes for each MP and each party and connect them
LOAD CSV WITH HEADERS FROM "https://github.com/mneedham/graphing-brexit/raw/master/data/mps.csv" AS row
MERGE (person:Person {name: row.mp})
MERGE (party:Party {name: row.party})
MERGE (person)-[:MEMBER_OF]->(party);

// Create a relationship between each MP and each motion
LOAD CSV WITH HEADERS FROM "https://github.com/mneedham/graphing-brexit/raw/master/data/votes.csv" AS row
MATCH (person:Person {name: row.person})
MATCH (motion:Motion {id: toInteger(row.motionId)})
CALL apoc.create.relationship(person, row.vote, {}, motion)
YIELD rel
RETURN rel;

LOAD CSV FROM "https://github.com/mneedham/graphing-brexit/raw/master/data/commonsvotes/Division655.csv" AS row
WITH collect(row) AS rows
MERGE (motion:Motion {division: trim(split(rows[0][0], ":")[1]) })
SET motion.name = rows[2][0]
WITH motion, rows
UNWIND rows[7..] AS row
MERGE (person:Person {name: row[0]})
MERGE (party:Party {name: row[1]})
MERGE (constituency:Constituency {name: row[2]})
MERGE (person)-[:MEMBER_OF]->(party)
MERGE (person)-[:REPRESENTS]->(constituency)