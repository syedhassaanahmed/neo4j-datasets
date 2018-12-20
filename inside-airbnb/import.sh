#!/bin/bash

ALLOWED_SIZE=$(($FILE_LIMIT_MB * 1024 * 1024))

# extract unique latest (not archived) csv.gz urls for each city
curl -s http://insideairbnb.com/get-the-data.html | tr -d '\n' | \
grep -Po '(?<=<tr class=""> ).*?(?= </tr>)' | grep -Po '(?<=href=")[^"]*/data/' | uniq | \
while read -r url ; do
    echo $url
    curl -o import/listings.csv.gz --max-filesize $ALLOWED_SIZE ${url}listings.csv.gz
    curl -o import/reviews.csv.gz --max-filesize $ALLOWED_SIZE ${url}reviews.csv.gz
    gunzip -f import/*.csv.gz

    # Both listings and reviews must be downloaded
    NUM_FILES=$(ls import | grep '\.csv$' | wc -l)
    if [ $NUM_FILES -lt 2 ]; then echo "Zipped csv data > ${FILE_LIMIT_MB}M, skipping..."; continue; fi

    if [[ $(find import -type f -size +${ALLOWED_SIZE}c) ]]; then 
        echo "Unzipped csv data > ${FILE_LIMIT_MB}M, skipping..."
    else
        # import city data
        bin/cypher-shell < import.cypher
    fi
done