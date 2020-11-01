// Create a few indexes to accelerate data load and initial lookups for traversal starting nodes.
CREATE INDEX ON :Person(nhs_no);
CREATE INDEX ON :Email(email_address);
CREATE INDEX ON :Phone(phoneNo);

// Load data on persons
USING PERIODIC COMMIT
LOAD CSV FROM "https://raw.githubusercontent.com/jbarrasa/datasets/master/safeguarding/vulnerable_people.csv" AS row
CREATE (p:Person {nhs_no: row[0], name: row[1], surname: row[2], dob:row[7]})
MERGE (a:Address { address:row[5], postcode:row[4]})
CREATE (p)-[:CURRENT_ADDRESS]->(a)
WITH row, p
WHERE row[6] IS NOT NULL
CREATE (f:Phone{ phoneNo:row[6]})
CREATE (p)-[:HAS_PHONE]->(f)
WITH row, p
WHERE row[3] IS NOT NULL
CREATE (e:Email{ email_address:row[3]})
CREATE (p)-[:HAS_EMAIL]->(e);

//Extract postcodes and areas from addresses
MATCH (a:Address)
MERGE (p:PostCode {code: a.postcode})
MERGE (a)-[:HAS_POSTCODE]->(p)
MERGE (z:Area {areaCode: substring(a.postcode,0,3)})
MERGE (p)-[:CODE_IN_AREA]->(z)
MERGE (a)-[:ADDRESS_IN_AREA]->(z)

// Load family connections
USING PERIODIC COMMIT
LOAD CSV FROM "https://raw.githubusercontent.com/jbarrasa/datasets/master/safeguarding/FAMILY_DATA.csv" AS row
MATCH (p1:Person {nhs_no: row[0]}),(p2:Person {nhs_no: row[1]})
CREATE (p1)-[:FAMILY_REL{rel_type: row[2]}]->(p2)
MERGE (p1)-[:KNOWS]-(p2)

// Load data from social networks
USING PERIODIC COMMIT
LOAD CSV FROM "https://raw.githubusercontent.com/jbarrasa/datasets/master/safeguarding/SOCIAL_NETWORKS.csv" AS row
MATCH (e1:Email{ email_address:row[0]}), (e2:Email{ email_address:row[1]}), (p1)-[:HAS_EMAIL]->(e1), (p2)-[:HAS_EMAIL]->(e2)
MERGE (p1)-[:KNOWS_SN]-(p2)
MERGE (p1)-[:KNOWS]-(p2)

// Load social workers reports
USING PERIODIC COMMIT
LOAD CSV FROM "https://raw.githubusercontent.com/jbarrasa/datasets/master/safeguarding/SOCIAL_WORKER_REPORT_EVENTS.csv" AS row
MATCH (p:Person {nhs_no: row[0]})
CREATE (e:Event:SocialWorkerReportedEvent { event_category: row[4], event_desc:row[3], event_date:row[1], event_risk_score:toInteger(row[2])})
CREATE (p)<-[:REPORTED_EVENT]-(e)

// Load police reports
USING PERIODIC COMMIT
LOAD CSV FROM "https://raw.githubusercontent.com/jbarrasa/datasets/master/safeguarding/POLICE_REPORT.csv" AS row
MATCH (p:Person {nhs_no: row[3]})
CREATE (e:Event:PoliceReportedEvent { event_category: row[2], event_desc:row[1], event_date:row[0], event_risk_score:100*rand()})
CREATE (p)<-[:REPORTED_EVENT]-(e)

// Load Phone Calls from call data records (CDRs)
USING PERIODIC COMMIT
LOAD CSV FROM "https://raw.githubusercontent.com/jbarrasa/datasets/master/safeguarding/CDRs_2015.csv" AS row
MATCH (f1:Phone{ phoneNo:row[4]}), (f2:Phone{ phoneNo:row[5]})
CREATE (pc:PhoneCall {call_date: row[3], call_type: row[2], call_duration:row[1], call_time:row[0]}),
(f1)<-[:CALLER]-(pc)-[:CALLED]->(f2)
WITH f1,f2
MATCH (p1)-[:HAS_PHONE]->(f1), (p2)-[:HAS_PHONE]->(f2)
MERGE (p1)-[:KNOWS_PHONE]-(p2)
MERGE (p1)-[:KNOWS]-(p2)