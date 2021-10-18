FROM neo4j:4.2 AS build
ENV CITY_BASE_URL="http://data.insideairbnb.com/united-states/or/salem-or/2021-09-25/data"
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
COPY import.cypher ./
RUN apt-get update && \
    apt-get install -y curl && \
    echo "dbms.import.csv.legacy_quote_escaping=false" >> conf/neo4j.conf && \
    chmod +x *.sh && ./neo4j-start.sh && \
    curl -o import/listings.csv.gz ${CITY_BASE_URL}/listings.csv.gz && \
    curl -o import/reviews.csv.gz ${CITY_BASE_URL}/reviews.csv.gz && \
    gunzip -f import/*.csv.gz && \
    bin/cypher-shell < import.cypher && \
    cp -r data/databases/neo4j /databases_tmp && \
    cp -r data/transactions/neo4j /transactions_tmp

FROM neo4j:4.2 AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /databases_tmp/ /data/databases/neo4j
COPY --chown=neo4j:neo4j --from=build /transactions_tmp/ /data/transactions/neo4j