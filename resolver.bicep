targetScope = 'resourceGroup'

param rgLocation string = 'uksouth'
param coreVnet string = 'TestDNS'

var vnetLinks = json(loadTextContent('./config/vnetlinks.json'))
var forwardingRules = json(loadTextContent('./config/forwardingrules.json'))


resource dnsresolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: 'TestDNS'
  location: rgLocation
  properties: {
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', coreVnet)
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
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', coreVnet, 'snet-inbound' )
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
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', coreVnet, 'snet-outbound' )
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

resource vnetLink 'Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks@2022-07-01' = [for vnetLink in vnetLinks.vnetlinks: {
  name: 'myruleset/${vnetLink.vnet}'
  dependsOn: [myruleset]
  properties: {
    virtualNetwork: {
      id: resourceId(vnetLink.sub,vnetLink.rg,'Microsoft.Network/virtualNetworks', vnetLink.vnet)
    }
  }
}]

resource contosorule 'Microsoft.Network/dnsForwardingRulesets/forwardingRules@2022-07-01' = [for forwardingRule in forwardingRules.forwardingrules: {
  name: 'myruleset/${forwardingRule.name}'
  dependsOn: [vnetLink]
  properties: {
    domainName: forwardingRule.domain
    targetDnsServers: [ for dnsserver in forwardingRule.ipaddress: {
      ipAddress: dnsserver
      port: 53
    }]
    forwardingRuleState: 'Enabled'
  }
}]
