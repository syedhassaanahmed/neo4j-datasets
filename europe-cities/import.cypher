LOAD CSV WITH HEADERS FROM 
"https://raw.githubusercontent.com/geoiq/acetate/master/places/Europe-z4-z6.txt"
as row FIELDTERMINATOR "\t"
MERGE (city:City{name: row.name})
ON CREATE SET city.population = toINT(row.population)
MERGE (country:Country{code: row.`country code`})
MERGE (city)-[:IS_IN]->(country);

MATCH (city:City)-[:IS_IN]->(country)
CALL apoc.spatial.geocodeOnce(city.name + " " + country.code) 
YIELD location
// Save response
SET city.latitude = location.latitude,
    city.longitude = location.longitude;

WITH 250 as distanceInKm
MATCH (c1:City),(c2:City)
WHERE id(c1) < id(c2)
WITH c1,c2,
distance(point({longitude:c1.longitude,latitude:c1.latitude}), 
         point({longitude:c2.longitude,latitude:c2.latitude})) as distance
WHERE distance < (distanceInKm * 1000) 
MERGE (c1)-[l:LINK]->(c2)
ON CREATE SET l.distance = distance;