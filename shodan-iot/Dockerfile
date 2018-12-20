FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
RUN apk add --no-cache curl git && \
    git clone https://github.com/johnymontana/neo4j-datasets.git && \
    mv ./neo4j-datasets/iot/data/*.csv ./import && \
    chmod +x *.sh && ./neo4j-start.sh && \
    bin/cypher-shell < neo4j-datasets/iot/src/import/import.cypher && \
    cp -r data/databases /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/