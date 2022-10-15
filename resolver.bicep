targetScope = 'resourceGroup'

param rgLocation string = 'uksouth'

resource dnsresolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: 'TestDNS'
  location: rgLocation
  properties: {
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', 'TestDNS')
    }
  }
}

resource inbound 'Microsoft.Network/dnsResolvers/inboundEndpoints@2022-07-01' = {
  name: 'TestDNS/myinboundendpoint'
  location: rgLocation
  dependsOn: [dnsresolver]
  properties: {
    ipConfigurations: [
      {
        subnet: {
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'TestDNS', 'snet-inbound' )
        }
        // privateIpAllocationMethod: 'Dynamic'
      }
    ]
  }
}

resource outbound 'Microsoft.Network/dnsResolvers/outboundEndpoints@2022-07-01' = {
  name: 'TestDNS/myoutboundendpoint'
  location: rgLocation
  dependsOn: [dnsresolver]
  properties: {
    subnet: {
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'TestDNS', 'snet-outbound' )
    }
  }
}

resource myruleset 'Microsoft.Network/dnsForwardingRulesets@2022-07-01' = {
  name: 'myruleset'
  location: rgLocation
  properties: {
    dnsResolverOutboundEndpoints: [
      {
        id: outbound.id
      }
    ]
  }
}

resource vnetlink 'Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks@2022-07-01' = {
  name: 'myruleset/TestDNS-Link'
  properties: {
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', 'TestDNS')
    }
  }
}

resource contosorule 'Microsoft.Network/dnsForwardingRulesets/forwardingRules@2022-07-01' = {
  name: 'myruleset/contosocom'
  dependsOn: [myruleset]
  properties: {
    domainName: 'contoso.com.'
    targetDnsServers: [
      {
        ipAddress: '11.0.1.4'
        port: 53
      }
      {
        ipAddress: '11.0.1.5'
        port: 53
      }
    ]
    forwardingRuleState: 'Enabled'
  }
}
