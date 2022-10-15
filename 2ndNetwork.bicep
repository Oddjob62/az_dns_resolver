targetScope = 'resourceGroup'

param rgLocation string = 'uksouth'

resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: 'TestDNS'
  location: rgLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.2.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'snet-inbound'
        properties: {
          addressPrefix: '10.2.1.0/28'
          delegations: [
            {
              name: 'Microsoft.Network.dnsResolvers'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
              }
            }
          ]
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'snet-outbound'
        properties: {
          addressPrefix: '10.2.1.16/28'
          delegations: [
            {
              name: 'Microsoft.Network.dnsResolvers'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
              }
            }
          ]
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource TestVnet2_1 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: 'TestVnet2_1'
  location: rgLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.101.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.101.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource TestVnet2_2 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: 'TestVnet2_2'
  location: rgLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.102.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.102.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }
}
