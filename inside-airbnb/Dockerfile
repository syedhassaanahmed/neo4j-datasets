FROM neo4j
LABEL maintainer="Syed Hassaan Ahmed"

ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/johnymontana/neo4j-datasets/master/airbnb/src/import/import.cypher ./

COPY import.sh ./

RUN chmod +x *.sh && apk add --update grep curl && rm -rf /var/cache/apk/*

ENV FILE_LIMIT_MB=2

CMD ["./import.sh"]