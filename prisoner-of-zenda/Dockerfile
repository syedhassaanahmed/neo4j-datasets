FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
ADD --chown=neo4j:neo4j https://github.com/neo4j-contrib/neo4j-graph-algorithms/releases/download/3.5.4.0/graph-algorithms-algo-3.5.4.0.jar ./plugins
COPY spacy_neo4j.py ./
RUN apt-get update && \
    apt-get install -y curl python3 python3-pip python3-setuptools && \
    pip3 install setuptools wheel --upgrade && \
    pip3 install spacy neo4j && \
    chmod +x *.sh && ./neo4j-start.sh && \
    python3 -m spacy download en_core_web_lg && \
    python3 spacy_neo4j.py && \
    cp -r data/databases/graph.db /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /graph.db/ /data/databases/graph.db