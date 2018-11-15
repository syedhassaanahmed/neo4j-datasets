FROM neo4j AS build
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/import.sh ./
RUN apk add --update curl && \
    apk add --no-cache git && \
    git clone https://github.com/johnymontana/neo4j-datasets.git && \
    mv ./neo4j-datasets/iot/data/*.csv ./import && \
    mv ./neo4j-datasets/iot/src/import/import.cypher ./ && \
    chmod +x *.sh && ./import.sh

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/