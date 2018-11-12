FROM neo4j
LABEL maintainer="Syed Hassaan Ahmed"

ENV SE_ARCHIVE_7Z_URL=https://archive.org/download/stackexchange/windowsphone.stackexchange.com.7z

COPY import.sh ./

RUN apk add --update curl && rm -rf /var/cache/apk/* && \
    apk add --no-cache git python3 p7zip && \
    python3 -m ensurepip && \
    pip3 install xmltodict && \
    git clone https://github.com/mdamien/stackoverflow-neo4j && \
    chown -R neo4j:neo4j stackoverflow-neo4j && \
    chmod +x *.sh

CMD ["./import.sh"]