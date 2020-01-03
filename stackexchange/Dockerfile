FROM neo4j AS build
ARG SE_ARCHIVE_7Z_URL=https://archive.org/download/stackexchange/windowsphone.stackexchange.com.7z
ENV SE_ARCHIVE_7Z_URL=${SE_ARCHIVE_7Z_URL}
COPY import.sh ./
RUN apt-get update && \
    apt-get install -y curl git python3 python3-pip p7zip-full && \
    pip3 install xmltodict && \
    git clone https://github.com/mdamien/stackoverflow-neo4j && \
    chmod +x *.sh && ./import.sh && \
    cp -r data/databases/graph.db /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /graph.db/ /data/databases/graph.db