FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
RUN apt-get update && \
    apt-get install -y curl git && \
    git clone https://github.com/mneedham/neo4j-worldcup && \
    chmod +x *.sh && ./neo4j-start.sh && \
    bin/cypher-shell < neo4j-worldcup/data/import/indexes.cyp && \
    bin/cypher-shell < neo4j-worldcup/data/import/loadMatches.cyp && \
    bin/cypher-shell < neo4j-worldcup/data/import/loadSquads.cyp && \
    bin/cypher-shell < neo4j-worldcup/data/import/loadLineUps.cyp && \
    bin/cypher-shell < neo4j-worldcup/data/import/loadEvents.cyp && \
    bin/cypher-shell < neo4j-worldcup/data/import/connectAdjacentWorldCups.cyp && \
    bin/cypher-shell < neo4j-worldcup/data/import/addGeoLocations.cyp && \
    bin/cypher-shell < neo4j-worldcup/data/import/loadCountryInformation.cyp && \
    bin/cypher-shell < neo4j-worldcup/data/import/addContinents.cyp && \
    cp -r data/databases/graph.db /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /graph.db/ /data/databases/graph.db