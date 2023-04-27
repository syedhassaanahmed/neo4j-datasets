# neo4j-datasets
[![Build Status](https://dev.azure.com/syedhassaanahmed/neo4j-datasets/_apis/build/status/neo4j-datasets-CI?branchName=master)](https://dev.azure.com/syedhassaanahmed/neo4j-datasets/_build/latest?definitionId=10&branchName=master)

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsyedhassaanahmed%2Fneo4j-datasets%2Fmaster%2Fazuredeploy.json)

Deploy single instance `Neo4j` server with optional publicly available datasets on `Azure Container Instances`. [These are the docker images](https://github.com/syedhassaanahmed/neo4j-datasets/blob/master/azuredeploy.json#L8) currently supported.

To deploy the template using CLI;
```
az group deployment create -g neo4j-game-of-thrones \
    --template-file azuredeploy.json \
    --parameters \
        image=syedhassaanahmed/neo4j-game-of-thrones \
        neo4jPassword=<NEO4J_PASSWORD> \
        migrateToCosmosDb=true \
        cosmosDbPartitionKey=name
```

Based on [official performance tuning guidelines](https://neo4j.com/developer/guide-performance-tuning/), Neo4j server is configured with the following value for `dbms.memory.pagecache.size`, `dbms.memory.heap.initial_size` and `dbms.memory.heap.max_size`
> `(CONTAINER_MEMORY_IN_GB - 1GB) / 2` (1GB reserved for other activities on server) i.e for a 7GB container, page cache size and heap size will have 3GB each.

## Browse data
Once deployment is completed, proceed to the newly created `Container group` and select `Overview` to get Public IP. Launch web browser at `http://<PUBLIC_IP>:7474` (ignore certificate warnings). Login with credentials `neo4j/<NEO4J_PASSWORD>`

## Migrate to Azure Cosmos DB
The template also allows you to optionally migrate data to Cosmos DB using [neo-to-cosmos](https://github.com/syedhassaanahmed/neo-to-cosmos) tool. 

**Note:** This will additionally deploy Cosmos DB and an Azure Container Instance of `neo-to-cosmos`.

## Troubleshoot
Install the [latest Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest).

If you've forgotten your Neo4j credentials, here is how to retrieve them from the [secure environment variable](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-environment-variables#secure-values) `NEO4J_AUTH`.

```
az container exec -g <RESOURCE_GROUP> -n <CONTAINER_NAME> --exec-command "echo $NEO4J_AUTH"
```

[Here is a detailed guide](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-troubleshooting) for troubleshooting Azure Container Instances.
