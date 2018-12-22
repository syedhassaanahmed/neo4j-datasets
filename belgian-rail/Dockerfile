FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
ADD --chown=neo4j:neo4j https://www.dropbox.com/s/2ti020s19zb1hb8/nmbs.zip?dl=1 ./
COPY import.cypher ./
RUN apk add --no-cache curl && \
    mkdir import/nmbs && unzip nmbs.zip -d import/nmbs && \
    chmod +x *.sh && ./neo4j-start.sh && \
    bin/cypher-shell < import.cypher && \
    cp -r data/databases /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/