#!/bin/bash

cd stackoverflow-neo4j

# -L because archive.org uses redirection
curl -O -L $SE_ARCHIVE_7Z_URL

for i in *.7z; do 7za -y -oextracted x $i; done
python3 to_csv.py extracted

../bin/neo4j-admin import\
    --id-type string \
    --nodes:Post csvs/posts.csv \
    --nodes:User csvs/users.csv \
    --nodes:Tag csvs/tags.csv \
    --relationships:PARENT_OF csvs/posts_rel.csv \
    --relationships:HAS_TAG csvs/tags_posts_rel.csv \
    --relationships:POSTED csvs/users_posts_rel.csv

# copy databases to root so that we can put them in final container during the build pipeline
cp -r /var/lib/neo4j/data/databases /