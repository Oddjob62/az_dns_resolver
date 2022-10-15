az account set --subscription AB_SECONDARY
az group create --location uksouth --resource-group TestDNS
az deployment group create --subscription AB_SECONDARY --resource-group TestDNS --template-file 2ndnetwork.bicep

az account set --subscription AB_MAIN
az group create --location uksouth --resource-group TestDNS
az deployment group create --subscription AB_MAIN --resource-group TestDNS --template-file network.bicep
az deployment group create --subscription AB_MAIN --resource-group TestDNS --template-file resolver.bicep --what-if
az deployment group create --subscription AB_MAIN --resource-group TestDNS --template-file resolver.bicep
