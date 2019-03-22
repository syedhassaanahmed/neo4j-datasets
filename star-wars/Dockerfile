FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
COPY swapi.py ./
RUN apk add --no-cache curl python3-dev build-base libffi-dev openssl-dev && \
    python3 -m ensurepip && \
    pip3 install py2neo requests && \
    chmod +x *.sh && ./neo4j-start.sh && \
    python3 swapi.py && \
    cp -r data/databases /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/