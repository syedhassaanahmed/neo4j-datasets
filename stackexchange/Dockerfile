FROM neo4j AS build
ARG SE_ARCHIVE_7Z_URL=https://archive.org/download/stackexchange/windowsphone.stackexchange.com.7z
ENV SE_ARCHIVE_7Z_URL=${SE_ARCHIVE_7Z_URL}
COPY import.sh ./
RUN apk add --update curl && \
    apk add --no-cache git python3 p7zip && \
    python3 -m ensurepip && \
    pip3 install xmltodict && \
    git clone https://github.com/mdamien/stackoverflow-neo4j && \
    chown -R neo4j:neo4j stackoverflow-neo4j && \
    chmod +x *.sh && ./import.sh

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/