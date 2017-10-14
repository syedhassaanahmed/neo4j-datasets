# aci-deploy-neo4j
[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://azuredeploy.net/)

Deploy publicly available `Neo4j` datasets on `Azure Container Instances`. [These are the Neo4j-based docker images](https://github.com/syedhassaanahmed/aci-deploy-neo4j/blob/master/azuredeploy.json#L8) currently allowed.

## Browse data
Once deployment is completed, proceed to the newly created `Container group` and select `Overview` to get Public IP. Launch web browser at `http://<public_ip>:7474` 

Login with credentials `neo4j/<password_you_provided_at_deployment>`

## Troubleshoot
Install the [latest Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) and follow [this guide](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-troubleshooting) for troubleshooting Azure Container Instances.