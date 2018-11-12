FROM neo4j
LABEL maintainer="Syed Hassaan Ahmed"

ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/import.sh ./

COPY import.cypher ./
RUN chmod +x *.sh && apk add --update curl && rm -rf /var/cache/apk/*

CMD ["./import.sh"]