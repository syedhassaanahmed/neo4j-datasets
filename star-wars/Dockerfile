FROM neo4j:4.2 AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
COPY swapi.py ./
RUN apt-get update && \
    apt-get install -y curl python3 python3-pip python3-setuptools && \
    pip3 install setuptools wheel --upgrade && \
    pip3 install py2neo requests && \
    chmod +x *.sh && ./neo4j-start.sh && \
    python3 swapi.py && \
    cp -r data/databases/neo4j /databases_tmp && \
    cp -r data/transactions/neo4j /transactions_tmp

FROM neo4j:4.2 AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /databases_tmp/ /data/databases/neo4j
COPY --chown=neo4j:neo4j --from=build /transactions_tmp/ /data/transactions/neo4j