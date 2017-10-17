# aci-deploy-neo4j
[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://azuredeploy.net/)

Deploy publicly available `Neo4j` datasets on `Azure Container Instances`. [These are the Neo4j-based docker images](https://github.com/syedhassaanahmed/aci-deploy-neo4j/blob/master/azuredeploy.json#L8) currently allowed.

Based on [official performance tuning guidelines](https://neo4j.com/developer/guide-performance-tuning/), Neo4j server is configured with the following value for `dbms.memory.pagecache.size` and `dbms.memory.heap.maxSize`
> `("Container's memory in GB" - 1GB) / 2` (1GB reserved for other activities on server) i.e for a 7GB container, page cache size and heap size will have 3GB each.

## Browse data
Once deployment is completed, proceed to the newly created `Container group` and select `Overview` to get Public IP. Launch web browser at `https://<public_ip>:7473` (ignore certificate warnings). Login with credentials `neo4j/<password_you_provided_at_deployment>`

## Troubleshoot
Install the [latest Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

Since actual data is downloaded when container starts, it may take a while before Neo4j Bolt server is established. To check that, run this in Azure CLI
```
az container logs -g <RESOURCE_GROUP> -n <CONTAINER NAME>
```

If you've forgotten your credentials, run this and it will spit out a json containing the environment variable `NEO4J_AUTH`.

```
az container show -g <RESOURCE_GROUP> -n <CONTAINER NAME>
```

[Here is a detailed guide](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-troubleshooting) for troubleshooting Azure Container Instances.