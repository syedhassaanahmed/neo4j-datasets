FROM golang:alpine AS scrape
ENV GOBIN=$GOPATH/bin
ADD https://raw.githubusercontent.com/mneedham/neo4j-thoughtworks-radar/master/cmd/parallel/main.go ./
ADD https://www.thoughtworks.com/radar/a-z rawData/twRadar.html
RUN apk add --no-cache git && \
    go get golang.org/x/text/encoding && \
    go get golang.org/x/crypto/ssh/terminal && \
    go get -v ./... && \
    mkdir rawData/items import && \
    go run -v main.go

FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
ADD --chown=neo4j:neo4j https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.5.0.2/apoc-3.5.0.2-all.jar ./plugins
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-thoughtworks-radar/master/import.cypher ./
COPY --from=scrape /go/import/*.csv ./import/
RUN apk add --no-cache curl && \
    chmod +x *.sh && ./neo4j-start.sh && \
    bin/cypher-shell < import.cypher && \
    cp -r data/databases /

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --from=build /databases/ /data/databases/