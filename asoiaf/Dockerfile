FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
ADD --chown=neo4j:neo4j https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.5.0.1/apoc-3.5.0.1-all.jar ./plugins
ADD --chown=neo4j:neo4j https://github.com/neo4j-contrib/neo4j-graph-algorithms/releases/download/3.5.0.1/graph-algorithms-algo-3.5.0.1.jar ./plugins
COPY import.cypher ./
RUN apk add --no-cache curl && \
    chmod +x *.sh && ./neo4j-start.sh && \
    bin/cypher-shell < import.cypher && \
    cp -r data/databases /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/