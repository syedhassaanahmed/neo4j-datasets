CREATE CONSTRAINT ON (u:User) ASSERT u.id is unique;

USING PERIODIC COMMIT 5000
LOAD CSV FROM 
"file:///facebook_combined.txt" as row fieldterminator ' '
MERGE (u:User{id:row[0]})
MERGE (u1:User{id:row[1]})
MERGE (u)-[:FRIEND]-(u1);