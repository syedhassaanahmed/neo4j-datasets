FROM neo4j AS build
ARG FILE_LIMIT_MB=2
ENV FILE_LIMIT_MB=${FILE_LIMIT_MB}
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/johnymontana/neo4j-datasets/master/airbnb/src/import/import.cypher ./
COPY import.sh ./
RUN apk add --no-cache curl grep && \
    chmod +x *.sh && ./neo4j-start.sh && \
    ./import.sh && \
    cp -r data/databases /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/