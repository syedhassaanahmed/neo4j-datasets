FROM neo4j AS build
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/import.sh ./
ADD --chown=neo4j:neo4j https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.4.0.3/apoc-3.4.0.3-all.jar ./plugins
COPY import.cypher ./
RUN chmod +x *.sh && apk add --update curl && ./import.sh

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/