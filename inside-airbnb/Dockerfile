FROM neo4j AS build
ARG FILE_LIMIT_MB=2
ENV FILE_LIMIT_MB=${FILE_LIMIT_MB}
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/johnymontana/neo4j-datasets/master/airbnb/src/import/import.cypher ./
COPY import.sh ./
RUN chmod +x *.sh && apk add --update grep curl && ./import.sh

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/