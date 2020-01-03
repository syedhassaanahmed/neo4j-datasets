FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=neo
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
ADD --chown=neo4j:neo4j https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.5.0.6/apoc-3.5.0.6-all.jar ./plugins
ADD https://raw.githubusercontent.com/mneedham/python-dependency-graph/master/deps.py ./
RUN apt-get update && \
    apt-get install -y curl python3 python3-pip python3-setuptools && \
    pip3 install neo4j-driver requests && \
    chmod +x *.sh && ./neo4j-start.sh && \
    python3 deps.py && \
    cp -r data/databases/graph.db /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /graph.db/ /data/databases/graph.db