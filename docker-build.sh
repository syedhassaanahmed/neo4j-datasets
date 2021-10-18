#!/bin/bash
set -euo pipefail

NEO4J_PORT=7474

for f in *; do
    IMAGE_NAME=$DOCKER_ID/neo4j-$f
    IMAGE_ID=$(docker images $IMAGE_NAME --format "{{.ID}}")

    if [ -d ${f} ] && [ -z "$IMAGE_ID" ]; then
        cd $f

        docker build -t $IMAGE_NAME .
        docker run --name $f -d -p $NEO4J_PORT:$NEO4J_PORT -e "NEO4J_AUTH=none" $IMAGE_NAME

        NEO4J_END="$((SECONDS+300))"
        while true; do
            [[ "200" = "$(curl --silent --write-out %{http_code} --output /dev/null http://localhost:$NEO4J_PORT)" ]] && break
            [[ "${SECONDS}" -ge "${NEO4J_END}" ]] && echo "Neo4j server took too long to start" && exit 1
            sleep 1
        done

        NODES=$(docker exec $f bin/cypher-shell "MATCH (n) RETURN COUNT(n)" | tail -1)
        echo "$f has $NODES nodes"

        RELATIONSHIPS=$(docker exec $f bin/cypher-shell "MATCH ()-[r]->() RETURN COUNT(r)" | tail -1)
        echo "$f has $RELATIONSHIPS relationships"

        docker rm -f $f
        docker builder prune -f

        if [ "$NODES" -lt 1 ] || [ "$RELATIONSHIPS" -lt 1 ]; then
            exit 1
        fi

        docker login -u $DOCKER_ID -p $DOCKER_PASSWORD
        docker push $IMAGE_NAME

        cd ..
    fi
done