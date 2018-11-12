FROM neo4j
LABEL maintainer="Syed Hassaan Ahmed"

ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/import.sh ./
ADD --chown=neo4j:neo4j https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.4.0.3/apoc-3.4.0.3-all.jar ./plugins

COPY import.cypher ./
RUN chmod +x *.sh && apk add --update curl && rm -rf /var/cache/apk/*

CMD ["./import.sh"]