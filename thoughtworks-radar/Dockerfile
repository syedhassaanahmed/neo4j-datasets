FROM golang:buster AS scrape
ENV GOROOT=/usr/local/go
ENV GOPATH=$HOME/workspace/go
ENV GOBIN=$GOPATH/bin
ENV PATH=$PATH:$GOPATH/bin:$GOROOT/bin
ADD https://raw.githubusercontent.com/mneedham/neo4j-thoughtworks-radar/master/cmd/parallel/main.go ./
ADD https://www.thoughtworks.com/radar/a-z rawData/twRadar.html
RUN go get golang.org/x/text/encoding && \
    go get -v ./... && \
    mkdir rawData/items import && \
    go run -v main.go

FROM neo4j AS build
ENV NEO4J_USERNAME=neo4j
ENV NEO4J_PASSWORD=temp-neo4j-password
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-datasets/master/neo4j-start.sh ./
ADD --chown=neo4j:neo4j https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/4.1.0.2/apoc-4.1.0.2-all.jar ./plugins
ADD --chown=neo4j:neo4j https://raw.githubusercontent.com/syedhassaanahmed/neo4j-thoughtworks-radar/master/import.cypher ./
COPY --from=scrape /go/import/*.csv ./import/
RUN apt-get update && \
    apt-get install -y curl && \
    chmod +x *.sh && ./neo4j-start.sh && \
    bin/cypher-shell < import.cypher && \
    cp -r data/databases/neo4j /databases_tmp && \
    cp -r data/transactions/neo4j /transactions_tmp

FROM neo4j AS final
LABEL maintainer="Syed Hassaan Ahmed"
COPY --chown=neo4j:neo4j --from=build /databases_tmp/ /data/databases/neo4j
COPY --chown=neo4j:neo4j --from=build /transactions_tmp/ /data/transactions/neo4j