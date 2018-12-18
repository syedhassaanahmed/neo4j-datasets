FROM neo4j AS build
ADD --chown=neo4j:neo4j https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.5.0.1/apoc-3.5.0.1-all.jar ./plugins
COPY import.sh ./
RUN apk add --update curl && \
    apk add --no-cache git && \
    git clone https://github.com/mneedham/football-transfers.git && \
    mv ./football-transfers/import/*.csv ./import/ && \
    chmod +x *.sh && ./import.sh

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/