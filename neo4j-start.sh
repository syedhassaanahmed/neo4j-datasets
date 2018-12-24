#!/bin/bash

# set temp password
bin/neo4j-admin set-initial-password $NEO4J_PASSWORD

# allow APOC procedures and Graph Algorithm to be executed without restrictions
echo "dbms.security.procedures.unrestricted=apoc.*,algo.*" >> conf/neo4j.conf

# start server
bin/neo4j start

# wait for server to kick in
NEO4J_END="$((SECONDS+300))"
while true; do
    [[ "200" = "$(curl --silent --write-out %{http_code} --output /dev/null http://localhost:7474)" ]] && break
    [[ "${SECONDS}" -ge "${NEO4J_END}" ]] && echo "Neo4j server took too long to start" && exit 1
    sleep 1
done