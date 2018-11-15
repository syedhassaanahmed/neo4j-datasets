# inside-airbnb
[![Docker Build Status](https://img.shields.io/docker/build/syedhassaanahmed/neo4j-inside-airbnb.svg?logo=docker)](https://hub.docker.com/r/syedhassaanahmed/neo4j-inside-airbnb/builds/) [![MicroBadger Size](https://img.shields.io/microbadger/image-size/syedhassaanahmed/neo4j-inside-airbnb.svg?logo=docker)](https://hub.docker.com/r/syedhassaanahmed/neo4j-inside-airbnb/tags/) [![Docker Pulls](https://img.shields.io/docker/pulls/syedhassaanahmed/neo4j-inside-airbnb.svg?logo=docker)](https://hub.docker.com/r/syedhassaanahmed/neo4j-inside-airbnb/)

Docker image hosting Neo4j Database of select cities from [Inside Airbnb](http://insideairbnb.com/get-the-data.html). Since data volume is huge and `LOAD CSV` is [not recommended for large datasets](https://neo4j.com/developer/guide-import-csv/#_super_fast_batch_importer_for_huge_datasets), selection of cities is dictated by limiting individual csv file size via environment variable `FILE_LIMIT_MB` (minimum 2 MB).

## Credits
- **Murray Cox** and **John Morris** who're behind Inside Airbnb.
- **William Lyon** for his [Cypher import queries](https://github.com/johnymontana/neo4j-datasets/blob/master/airbnb/src/import/import.cypher).