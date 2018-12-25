CALL apoc.schema.assert(
 {County:['name'],City:['name'],ZipCode:['name'],Address:['name']},
 {Hospital:['id'],State:['name']});

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/tomasonjo/hospitals-neo4j/master/Hospital%20General%20Information.csv" as row
// state name is unique
MERGE (state:State{name:row.State})
// merge by pattern with their parents
MERGE (state)<-[:IS_IN]-(county:County{name:row.`County Name`})
MERGE (county)<-[:IS_IN]-(city:City{name:row.City})
MERGE (city)<-[:IS_IN]-(zip:ZipCode{name:row.`ZIP Code`})
MERGE (zip)<-[:IS_IN]-(address:Address{name:row.Address})
// for entities it is best to have an id system
MERGE (h:Hospital{id:row.`Provider ID`})
ON CREATE SET h.phone=row.`Phone Number`,
              h.emergency_services = row.`Emergency Services`,
              h.name= row.`Hospital Name`,
              h.mortality = row.`Mortality national comparison`,
              h.safety = row.`Safety of care national comparison`,
              h.timeliness = row.`Timeliness of care national comparison`,
              h.experience = row.`Patient experience national comparison`,
              h.effectiveness = row.`Effectiveness of care national comparison`
MERGE (h)-[:IS_IN]->(address)
//Some metadata about hospitals
MERGE (type:HospitalType{name:row.`Hospital Type`})
MERGE (h)-[:HAS_TYPE]->(type)
MERGE (ownership:Ownership{name: row.`Hospital Ownership`})
MERGE (h)-[:HAS_OWNERSHIP]->(ownership)
MERGE (rating:Rating{name:row.`Hospital overall rating`})
MERGE (h)-[:HAS_RATING]->(rating);

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/tomasonjo/hospitals-neo4j/master/gpsinfo.csv" as row
MATCH (h:Hospital{id:row.id})
SET h.longitude = toFloat(row.longitude),h.latitude=toFloat(row.latitude)