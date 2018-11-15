FROM neo4j AS build
COPY import.sh ./
RUN apk add --update curl && \
    apk add --no-cache git && \
    git clone https://github.com/mneedham/neo4j-worldcup && \
    chmod +x *.sh && ./import.sh

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/