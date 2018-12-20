FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
RUN apk add --no-cache curl git && \
    git clone https://github.com/sfrechette/adventureworks-neo4j.git && \
    mv ./adventureworks-neo4j/data/ ./import/data/ && \
    chmod +x *.sh && ./neo4j-start.sh && \
    bin/cypher-shell < adventureworks-neo4j/cypher/import.cypher && \
    cp -r data/databases /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/