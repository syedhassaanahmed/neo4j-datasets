FROM neo4j

# Update certs and install openssl in order to make wget work on Alpine
RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl

# Download apoc neo4j plugin used inside below cypher script
RUN wget https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.2.0.4/apoc-3.2.0.4-all.jar -P plugins/

# Download and run the GoT cypher script with a temp password
RUN wget https://raw.githubusercontent.com/neo4j-examples/game-of-thrones/master/got-import.cypher &&\
    bin/neo4j-admin set-initial-password gotneo4j && \
    bin/neo4j start && \
    sleep 20 &&\
    bin/cypher-shell -u neo4j -p gotneo4j < got-import.cypher &&\
    bin/neo4j stop &&\
    rm -rf data/dbms/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["neo4j"]