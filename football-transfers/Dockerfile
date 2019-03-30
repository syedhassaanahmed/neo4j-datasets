FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
ADD --chown=neo4j:neo4j https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.5.0.2/apoc-3.5.0.2-all.jar ./plugins
RUN apk add --no-cache curl git && \
    git clone https://github.com/syedhassaanahmed/football-transfers.git && \
    mv ./football-transfers/import/*.csv ./import/ && \
    chmod +x *.sh && ./neo4j-start.sh && \
    bin/cypher-shell < football-transfers/cypher/schema.cql && \
    bin/cypher-shell < football-transfers/cypher/initial.cql && \
    bin/cypher-shell < football-transfers/cypher/add_nationality.cql && \
    bin/cypher-shell < football-transfers/cypher/add_countries_confederations.cql && \
    cp -r data/databases /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/