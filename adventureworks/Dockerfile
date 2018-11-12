FROM neo4j
LABEL maintainer="Syed Hassaan Ahmed"

ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/import.sh ./

RUN apk add --update curl && rm -rf /var/cache/apk/* && \
    apk add --no-cache git && \
    git clone https://github.com/sfrechette/adventureworks-neo4j.git && \
    mv ./adventureworks-neo4j/cypher/import.cypher ./ && \
    mv ./adventureworks-neo4j/data/ ./import/data/ && \
    chmod +x *.sh

CMD ["./import.sh"]