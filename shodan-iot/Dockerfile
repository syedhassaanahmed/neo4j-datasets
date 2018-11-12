FROM neo4j
LABEL maintainer="Syed Hassaan Ahmed"

ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/import.sh ./

RUN apk add --update curl && rm -rf /var/cache/apk/* && \
    apk add --no-cache git && \
    git clone https://github.com/johnymontana/neo4j-datasets.git && \
    mv ./neo4j-datasets/iot/data/*.csv ./import && \
    mv ./neo4j-datasets/iot/src/import/import.cypher ./ && \
    chmod +x *.sh

CMD ["./import.sh"]