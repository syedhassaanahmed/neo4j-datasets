FROM neo4j AS build
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/import.sh ./
RUN apk add --update curl && \
    apk add --no-cache git && \
    git clone https://github.com/sfrechette/adventureworks-neo4j.git && \
    mv ./adventureworks-neo4j/cypher/import.cypher ./ && \
    mv ./adventureworks-neo4j/data/ ./import/data/ && \
    chmod +x *.sh && ./import.sh

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/