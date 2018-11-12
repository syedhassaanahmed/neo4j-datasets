FROM neo4j
LABEL maintainer="Syed Hassaan Ahmed"

ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/import.sh ./

RUN apk add --update curl && rm -rf /var/cache/apk/* && \
    apk add --no-cache git && \
    git clone https://github.com/neo4j-contrib/developer-resources && \
    mv ./developer-resources/data/northwind/*.csv ./import && \
    chmod +x *.sh

COPY import.cypher ./
CMD ["./import.sh"]