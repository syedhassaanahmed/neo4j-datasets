FROM neo4j:4.2 AS build
ENV SE_ARCHIVE_7Z_URL=https://archive.org/download/stackexchange/windowsphone.stackexchange.com.7z
COPY import.sh ./
RUN apt-get update && \
    apt-get install -y curl git python3 python3-pip p7zip-full && \
    pip3 install xmltodict && \
    git clone https://github.com/mdamien/stackoverflow-neo4j && \
    chmod +x *.sh && ./import.sh && \
    cp -r data/databases/neo4j /databases_tmp && \
    cp -r data/transactions/neo4j /transactions_tmp

FROM neo4j:4.2 AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /databases_tmp/ /data/databases/neo4j
COPY --chown=neo4j:neo4j --from=build /transactions_tmp/ /data/transactions/neo4j