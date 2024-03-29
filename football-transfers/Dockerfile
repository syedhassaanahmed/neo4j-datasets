FROM neo4j:4.2 AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
ADD --chown=neo4j:neo4j https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/4.2.0.8/apoc-4.2.0.8-all.jar ./plugins
RUN apt-get update && \
    apt-get install -y curl git && \
    git clone https://github.com/mneedham/football-transfers.git && \
    mv ./football-transfers/import/*.csv ./import/ && \
    chmod +x *.sh && ./neo4j-start.sh && \
    bin/cypher-shell < football-transfers/cypher/schema.cql && \
    bin/cypher-shell < football-transfers/cypher/initial.cql && \
    bin/cypher-shell < football-transfers/cypher/add_nationality.cql && \
    bin/cypher-shell < football-transfers/cypher/add_countries_confederations.cql && \
    cp -r data/databases/neo4j /databases_tmp && \
    cp -r data/transactions/neo4j /transactions_tmp

FROM neo4j:4.2 AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /databases_tmp/ /data/databases/neo4j
COPY --chown=neo4j:neo4j --from=build /transactions_tmp/ /data/transactions/neo4j