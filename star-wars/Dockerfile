FROM neo4j AS build
COPY import.sh swapi.py ./
RUN apk add --update curl && \
    apk add --no-cache python3 && \
    python3 -m ensurepip && \
    pip3 install py2neo requests && \
    chmod +x *.sh && ./import.sh

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/