FROM neo4j AS build
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/import.sh ./
COPY import.cypher ./
RUN apk add --update curl && \
    apk add --no-cache git && \
    git clone https://github.com/neo4j-contrib/developer-resources && \
    mv ./developer-resources/data/northwind/*.csv ./import && \
    chmod +x *.sh && ./import.sh

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/