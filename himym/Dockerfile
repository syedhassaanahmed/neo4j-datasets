FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
RUN apt-get update && \
    apt-get install -y curl git && \
    git clone https://github.com/syedhassaanahmed/neo4j-himym.git && \
    mv ./neo4j-himym/data/import/*.csv ./import/ && \
    echo "dbms.memory.heap.max_size=1G" >> conf/neo4j.conf && \
    chmod +x *.sh && ./neo4j-start.sh && \
    find ./neo4j-himym/data/import/ -name '*.cql' -exec sed -i -e 's:/Users/markneedham/projects/neo4j-himym/data/import::g' {} \; && \
    bin/cypher-shell < neo4j-himym/data/import/indexes.cql && \
    bin/cypher-shell < neo4j-himym/data/import/himym.cql && \
    bin/cypher-shell < neo4j-himym/data/import/references.cql && \
    bin/cypher-shell < neo4j-himym/data/import/tfidf.cql && \
    bin/cypher-shell < neo4j-himym/data/import/words.cql && \
    bin/cypher-shell < neo4j-himym/data/import/tfidf_scikit.cql && \
    cp -r data/databases/graph.db /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /graph.db/ /data/databases/graph.db