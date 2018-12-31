#!/bin/bash
set -euo pipefail

for f in *; do
    if [ -d ${f} ]; then
        cd $f
        IMAGE_NAME=$DOCKER_ID/neo4j-$f
        docker build -t $IMAGE_NAME .
        docker login -u $DOCKER_ID -p $DOCKER_PASSWORD
        docker push $IMAGE_NAME
        cd ..
    fi
done