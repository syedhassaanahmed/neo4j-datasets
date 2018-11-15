#!/bin/bash

cd /var/lib/neo4j

# set temp password
TEMP_PASSWORD=temp-neo4j-password
bin/neo4j-admin set-initial-password $TEMP_PASSWORD

# allow all APOC procedures to be available to all users
echo "dbms.security.procedures.unrestricted=apoc.*" >> conf/neo4j.conf

# start server
bin/neo4j start

# wait for server to kick in
NEO4J_END="$((SECONDS+60))"
while true; do
    [[ "200" = "$(curl --silent --write-out %{http_code} --output /dev/null http://localhost:7474)" ]] && break
    [[ "${SECONDS}" -ge "${NEO4J_END}" ]] && echo "Neo4j server took too long to start" && exit 1
    sleep 1
done

# import data
bin/cypher-shell -u neo4j -p $TEMP_PASSWORD < import.cypher

# copy databases to root so that we can put them in final container during the build pipeline
cp -r /var/lib/neo4j/data/databases /