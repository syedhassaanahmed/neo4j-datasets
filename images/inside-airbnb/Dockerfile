FROM neo4j

# Update certs, install openssl, grep and curl
RUN apk update && apk add ca-certificates && update-ca-certificates &&\
    apk add openssl && apk --update add grep && apk add --update curl

COPY import.cypher import.cypher

# Start server with temp password, parse html for unique csv.gz links then download and import data
RUN bin/neo4j-admin set-initial-password insideairbnb &&\
    bin/neo4j start &&\
    curl -s http://insideairbnb.com/get-the-data.html | tr -d '\n' | \
    grep -Po '(?<=<tr class=""> ).*?(?= </tr>)' | grep -Po '(?<=href=")[^"]*/data/' | uniq | \
    while read -r url ; do \
        echo "$url"; \
        wget ${url}listings.csv.gz -P import; \
        wget ${url}reviews.csv.gz -P import; \
        gunzip -f import/*.csv.gz; \
        bin/cypher-shell -u neo4j -p insideairbnb < import.cypher; \
    done &&\
    bin/neo4j stop &&\
    rm -rf data/dbms/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["neo4j"]