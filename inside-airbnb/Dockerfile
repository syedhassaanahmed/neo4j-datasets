FROM neo4j AS build
ARG FILE_LIMIT_MB=3
ENV FILE_LIMIT_MB=${FILE_LIMIT_MB}
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
COPY import.sh import.cypher ./
RUN apt-get update && \
    apt-get install -y curl && \
    chmod +x *.sh && ./neo4j-start.sh && \
    ./import.sh && \
    cp -r data/databases/neo4j /databases_tmp && \
    cp -r data/transactions/neo4j /transactions_tmp

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /databases_tmp/ /data/databases/neo4j
COPY --chown=neo4j:neo4j --from=build /transactions_tmp/ /data/transactions/neo4j