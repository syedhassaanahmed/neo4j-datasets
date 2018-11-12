FROM neo4j
LABEL maintainer="Syed Hassaan Ahmed"

ADD --chown=neo4j:neo4j https://gist.githubusercontent.com/jexp/1e295d5f5b96e8e42fb614232abdbb4f/raw/ee277d2daec8aa54c031cbeede774abda9c9118b/neo4j-wait.sh ./
ADD --chown=neo4j:neo4j https://gist.githubusercontent.com/syedhassaanahmed/1809fcce4cb15daaff79690932ea76bd/raw/6f660641eccf662936b13cf077465fbf9a46c1d2/neo4j-import.sh ./import.sh

RUN apk add --update curl && rm -rf /var/cache/apk/* && \
    apk add --no-cache git && \
    git clone https://github.com/legis-graph/legis-graph.git && \
    mv ./legis-graph/outputs/*.csv ./import && \
    mv ./legis-graph/import.cypher ./ && \
    chmod +x *.sh
    
CMD ["./import.sh"]