FROM neo4j:4.2 AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
ADD http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=select+distinct+%3Fparty+%3Fcity+%3FcityName+%3Fctr+%3FctrName+%3Fpop+where+%7B%0D%0A%3Fcity+a+dbo%3ALocation+%3B%0D%0A++++++dbo%3Acountry+%3Fctr+%3B%0D%0A++++++dbo%3AleaderParty+%3Fparty+.%0D%0A%0D%0A%3Fctr+dct%3Asubject+dbc%3ACountries_in_Europe+.%0D%0A%0D%0A%3Fparty+dbo%3Aideology+%3Fideology+.%0D%0A%0D%0Aoptional+%7B+%3Fcity+dbo%3ApopulationTotal+%3Fpop+%7D%0D%0A%0D%0A%3Fcity+rdfs%3Alabel+%3FcityName%0D%0AFILTER%28langMatches%28lang%28%3FcityName%29%2C+%22EN%22%29%29%0D%0A%0D%0A%3Fctr+rdfs%3Alabel+%3FctrName%0D%0AFILTER%28langMatches%28lang%28%3FctrName%29%2C+%22EN%22%29%29%0D%0A%0D%0A%7D&format=csv import/cities.csv
ADD http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=select+distinct+%3Fparty+%3FpartyName+%3Fideology+%3FideologyName+where+%7B%0D%0A%0D%0A%3Fcity+a+dbo%3ALocation+%3B%0D%0A++++++dbo%3Acountry+%3Fctr+%3B%0D%0A++++++dbo%3AleaderParty+%3Fparty+.%0D%0A%0D%0A%3Fctr+dct%3Asubject+dbc%3ACountries_in_Europe+.%0D%0A%0D%0A%3Fparty+dbo%3Aideology+%3Fideology+%3B%0D%0A+++++++rdfs%3Alabel+%3FpartyName+.%0D%0AFILTER%28langMatches%28lang%28%3FpartyName%29%2C+%22EN%22%29%29%0D%0A%0D%0A%3Fideology+rdfs%3Alabel+%3FideologyName%0D%0AFILTER%28langMatches%28lang%28%3FideologyName%29%2C+%22EN%22%29%29%0D%0A%0D%0A%7D&format=csv import/parties.csv
COPY import.cypher ./
RUN apt-get update && \
    apt-get install -y curl && \
    chmod +x *.sh && ./neo4j-start.sh && \
    bin/cypher-shell < import.cypher && \
    cp -r data/databases/neo4j /databases_tmp && \
    cp -r data/transactions/neo4j /transactions_tmp

FROM neo4j:4.2 AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /databases_tmp/ /data/databases/neo4j
COPY --chown=neo4j:neo4j --from=build /transactions_tmp/ /data/transactions/neo4j