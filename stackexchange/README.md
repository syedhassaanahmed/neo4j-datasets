# stackexchange
[![Docker Build Status](https://img.shields.io/docker/cloud/build/syedhassaanahmed/neo4j-stackexchange.svg?logo=docker)](https://hub.docker.com/r/syedhassaanahmed/neo4j-stackexchange/builds/) [![MicroBadger Size](https://img.shields.io/microbadger/image-size/syedhassaanahmed/neo4j-stackexchange.svg?logo=docker)](https://hub.docker.com/r/syedhassaanahmed/neo4j-stackexchange/tags/) [![Docker Pulls](https://img.shields.io/docker/pulls/syedhassaanahmed/neo4j-stackexchange.svg?logo=docker)](https://hub.docker.com/r/syedhassaanahmed/neo4j-stackexchange/)

Docker image hosting Neo4j Database of [StackExchange sites](https://stackexchange.com/sites). Since data volume is large, site selection is dictated by environment variable `SE_ARCHIVE_7Z_URL`. URL can be retrieved from [this anonymized dump](https://archive.org/details/stackexchange) of Stack Exchange network. Default url points to the archive of `windowsphone.stackexchange.com` (yes I love beating dead horses :)).

## Credits
- **Stack Exchange, Inc.** for providing the Data Dump.
- **Michael Hunger** for his detailed blog post about [importing Stack Overflow Questions into Neo4j](https://neo4j.com/blog/import-10m-stack-overflow-questions/).
- **Damien Marié** for his [Python script](https://github.com/mdamien/stackoverflow-neo4j) to extract the CSV from XML with the necessary headers.