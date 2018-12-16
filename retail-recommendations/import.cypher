// Load product catalog
LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/u/1/d/1AL4uijztdNowNitO7H1aPJO1ZTxgpujyi7acRAA69FE/export?format=csv&id=1AL4uijztdNowNitO7H1aPJO1ZTxgpujyi7acRAA69FE&gid=0" AS row

MERGE (parent_category:Category {name: row.parent_category})
MERGE (category:Category {name: row.category})
MERGE (category)-[:PARENT_CATEGORY]->(parent_category)
MERGE (p:Product {sku: toString(row.sku)})
SET p.name  = row.name,
    p.price = toFloat(row.price)
MERGE (p)-[:IN_CATEGORY]->(category)
MERGE (d:Designer {name: row.designer})
MERGE (p)-[:DESIGNED_BY]-(d)
RETURN *;

// Load customers
LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/u/0/d/1wb7obY4WF08aeb4ey-NUsiB4BZzRHTDoGKZEH-jmv_k/export?format=csv&id=1wb7obY4WF08aeb4ey-NUsiB4BZzRHTDoGKZEH-jmv_k&gid=573101337" AS row
MERGE (c:Customer {customerid: row.customerid})
SET c.name = row.Name
MERGE (city:City {name: row.City})
MERGE (c)-[:LIVES_IN]->(city)
RETURN *;

// Load orders
LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/u/0/d/1wb7obY4WF08aeb4ey-NUsiB4BZzRHTDoGKZEH-jmv_k/export?format=csv&id=1wb7obY4WF08aeb4ey-NUsiB4BZzRHTDoGKZEH-jmv_k&gid=749858493" AS row
MERGE (o:Order {orderid: row.orderid})
WITH *
MATCH (c:Customer {customerid: row.customerid})
MATCH (p:Product {sku: row.sku})
MERGE (c)-[:PLACED]->(o)
MERGE (o)-[:CONTAINS]->(p)
RETURN *;

// Load customer reviews
CALL apoc.load.json("http://guides.neo4j.com/sandbox/retail-recommendations/data/reviews.json") YIELD value AS row
MATCH (c:Customer {customerid: toString(row.customerid)})
MATCH (p:Product {sku: toString(row.sku)})
MERGE (c)-[r:REVIEWED]->(p)
SET r.rating = round(toFloat(row.review))
RETURN *;

// Load inventory
LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/u/0/d/1wb7obY4WF08aeb4ey-NUsiB4BZzRHTDoGKZEH-jmv_k/export?format=csv&id=1wb7obY4WF08aeb4ey-NUsiB4BZzRHTDoGKZEH-jmv_k&gid=966157202" AS row
MERGE (s:Store {name: row.store})
WITH *
MATCH (c:City {name: row.store})
MERGE (s)-[:IN_CITY]-(c)
WITH *
MATCH (p:Product {sku: row.sku})
MERGE (p)-[r:INVENTORY]->(s)
SET r.count = toInt(row.number)
RETURN *;