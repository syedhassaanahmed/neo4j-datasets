#!/bin/bash
set -euo pipefail

NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=Neo4j
NEO4J_PORT=7474

for f in *; do
    if [ -d ${f} ]; then
        cd $f
        IMAGE_NAME=$DOCKER_ID/neo4j-$f
        docker build -t $IMAGE_NAME .

        docker run --name $f -d -p $NEO4J_PORT:$NEO4J_PORT -e "NEO4J_AUTH=$NEO4J_USERNAME/$NEO4J_PASSWORD" $IMAGE_NAME

        NEO4J_END="$((SECONDS+300))"
        while true; do
            [[ "200" = "$(curl --silent --write-out %{http_code} --output /dev/null http://localhost:$NEO4J_PORT)" ]] && break
            [[ "${SECONDS}" -ge "${NEO4J_END}" ]] && echo "Neo4j server took too long to start" && exit 1
            sleep 1
        done

        NODES=$(docker exec $f bin/cypher-shell -u $NEO4J_USERNAME -p $NEO4J_PASSWORD "MATCH (n) RETURN COUNT(n)" | tail -1)
        RELATIONSHIPS=$(docker exec $f bin/cypher-shell -u $NEO4J_USERNAME -p $NEO4J_PASSWORD "MATCH ()-[r]->() RETURN COUNT(r)" | tail -1)

        docker rm -f $f

        if [ "$NODES" -lt 1 ]; then
            echo "$f has $NODES nodes"
            exit 1
        fi

        if [ "$RELATIONSHIPS" -lt 1 ]; then
            echo "$f has $RELATIONSHIPS relationships"
            exit 1
        fi

        docker login -u $DOCKER_ID -p $DOCKER_PASSWORD
        docker push $IMAGE_NAME
        cd ..
    fi
done