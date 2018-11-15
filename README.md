# neo4j-datasets
[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsyedhassaanahmed%2Fneo4j-datasets%2Fmaster%2Fazuredeploy.json)

Deploy single instance `Neo4j` server with optional publicly available datasets on `Azure Container Instances`. [These are the supported docker images](https://github.com/syedhassaanahmed/neo4j-datasets/blob/master/azuredeploy.json#L8) currently supported. The project is described in detail in [this blog post](https://medium.com/@hasssaaannn/bringing-public-neo4j-graph-datasets-to-azure-cfc77f02bcbe).

To deploy the template using CLI;
```
az group deployment create -g neo4j-game-of-thrones --template-file azuredeploy.json --parameters image=syedhassaanahmed/neo4j-game-of-thrones neo4jPassword=<NEO4J_PASSWORD> migrateToCosmosDb=true
```

Based on [official performance tuning guidelines](https://neo4j.com/developer/guide-performance-tuning/), Neo4j server is configured with the following value for `dbms.memory.pagecache.size` and `dbms.memory.heap.maxSize`
> `(CONTAINER_MEMORY_IN_GB - 1GB) / 2` (1GB reserved for other activities on server) i.e for a 7GB container, page cache size and heap size will have 3GB each.

## Browse data
Once deployment is completed, proceed to the newly created `Container group` and select `Overview` to get Public IP. Launch web browser at `https://<PUBLIC_IP>:7473` (ignore certificate warnings). Login with credentials `neo4j/<NEO4J_PASSWORD>`

## Migrate to Cosmos DB
The template also allows you to optionally migrate data to Cosmos DB using [neo-to-cosmos](https://github.com/syedhassaanahmed/neo-to-cosmos) tool. 

**Note:** This will additionally deploy Cosmos DB, Redis Cache and 3 Azure Container Instances of `Neo2Cosmos`.

## Troubleshoot
Install the [latest Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

Since actual data is downloaded when container starts, it may take a while before Neo4j Bolt server is established. To check that, run this to get logs in Azure CLI
```
az container logs -g <RESOURCE_GROUP> -n <CONTAINER_NAME>
```
Or Attach to the container
```
az container attach -g <RESOURCE_GROUP> -n <CONTAINER_NAME>
```

If you've forgotten your credentials, run this and it will spit out a json containing the environment variable `NEO4J_AUTH`.

```
az container show -g <RESOURCE_GROUP> -n <CONTAINER_NAME>
```

[Here is a detailed guide](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-troubleshooting) for troubleshooting Azure Container Instances.