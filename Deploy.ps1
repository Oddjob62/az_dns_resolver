az group create --location uksouth --resource-group TestDNS
az deployment group create --resource-group TestDNS --template-file network.bicep
az deployment group create --resource-group TestDNS --template-file resolver.bicep --what-if
az deployment group create --resource-group TestDNS --template-file resolver.bicep