CREATE INDEX ON :City(city_uri);

WITH "http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=select+distinct+%3Fparty+%3Fcity+%3FcityName+%3Fctr+%3FctrName+%3Fpop+where+%7B%0D%0A%3Fcity+a+dbo%3ALocation+%3B%0D%0A++++++dbo%3Acountry+%3Fctr+%3B%0D%0A++++++dbo%3AleaderParty+%3Fparty+.%0D%0A%0D%0A%3Fctr+dct%3Asubject+dbc%3ACountries_in_Europe+.%0D%0A%0D%0A%3Fparty+dbo%3Aideology+%3Fideology+.%0D%0A%0D%0Aoptional+%7B+%3Fcity+dbo%3ApopulationTotal+%3Fpop+%7D%0D%0A%0D%0A%3Fcity+rdfs%3Alabel+%3FcityName%0D%0AFILTER%28langMatches%28lang%28%3FcityName%29%2C+%22EN%22%29%29%0D%0A%0D%0A%3Fctr+rdfs%3Alabel+%3FctrName%0D%0AFILTER%28langMatches%28lang%28%3FctrName%29%2C+%22EN%22%29%29%0D%0A%0D%0A%7D&format=csv" AS queryOnSPARQLEndpoint
LOAD CSV WITH HEADERS FROM queryOnSPARQLEndpoint AS row
WITH row
MERGE (cty:City {city_uri: row.city}) 
      SET cty.city_pop= coalesce(row.pop,0), cty.city_name = row.cityName
MERGE (ctr:Country {ctry_uri: row.ctr}) 
      SET ctr.ctry_name = row.ctrName
MERGE (pty:Party {party_uri: row.party})
MERGE (cty)-[:CTY_IN_COUNTRY]->(ctr)
MERGE (cty)-[:GOVERNING_PARTY]->(pty);

WITH "http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=select+distinct+%3Fparty+%3FpartyName+%3Fideology+%3FideologyName+where+%7B%0D%0A%0D%0A%3Fcity+a+dbo%3ALocation+%3B%0D%0A++++++dbo%3Acountry+%3Fctr+%3B%0D%0A++++++dbo%3AleaderParty+%3Fparty+.%0D%0A%0D%0A%3Fctr+dct%3Asubject+dbc%3ACountries_in_Europe+.%0D%0A%0D%0A%3Fparty+dbo%3Aideology+%3Fideology+%3B%0D%0A+++++++rdfs%3Alabel+%3FpartyName+.%0D%0AFILTER%28langMatches%28lang%28%3FpartyName%29%2C+%22EN%22%29%29%0D%0A%0D%0A%3Fideology+rdfs%3Alabel+%3FideologyName%0D%0AFILTER%28langMatches%28lang%28%3FideologyName%29%2C+%22EN%22%29%29%0D%0A%0D%0A%7D&format=csv" AS queryOnSPARQLEndpoint
LOAD CSV WITH HEADERS FROM queryOnSPARQLEndpoint AS row
WITH row
MERGE (pty:Party {party_uri: row.party}) 
      SET pty.party_name = row.partyName
MERGE (ide:Ideology {ideology_uri: row.ideology}) 
      SET ide.ideology_name = row.ideologyName
MERGE (pty)-[:HAS_IDEOLOGY]->(ide);