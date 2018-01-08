# aci-deploy-neo4j
[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://azuredeploy.net/)

Deploy single instance `Neo4j` server with optional publicly available datasets on `Azure Container Instances`. [These are the Neo4j-based docker images](https://github.com/syedhassaanahmed/aci-deploy-neo4j/blob/master/azuredeploy.json#L8) currently supported. The project is described in detail in [this blog post](https://medium.com/@hasssaaannn/bringing-public-neo4j-graph-datasets-to-azure-cfc77f02bcbe).

Based on [official performance tuning guidelines](https://neo4j.com/developer/guide-performance-tuning/), Neo4j server is configured with the following value for `dbms.memory.pagecache.size` and `dbms.memory.heap.maxSize`
> `(CONTAINER_MEMORY_IN_GB - 1GB) / 2` (1GB reserved for other activities on server) i.e for a 7GB container, page cache size and heap size will have 3GB each.

## Browse data
Once deployment is completed, proceed to the newly created `Container group` and select `Overview` to get Public IP. Launch web browser at `https://<PUBLIC_IP>:7473` (ignore certificate warnings). Login with credentials `neo4j/<PASSWORD_PROVIDED_AT_DEPLOYMENT>`

## Troubleshoot
Install the [latest Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

Since actual data is downloaded when container starts, it may take a while before Neo4j Bolt server is established. To check that, run this in Azure CLI
```
az container logs -g <RESOURCE_GROUP> -n <CONTAINER_NAME>
```

If you've forgotten your credentials, run this and it will spit out a json containing the environment variable `NEO4J_AUTH`.

```
az container show -g <RESOURCE_GROUP> -n <CONTAINER_NAME>
```

[Here is a detailed guide](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-troubleshooting) for troubleshooting Azure Container Instances.