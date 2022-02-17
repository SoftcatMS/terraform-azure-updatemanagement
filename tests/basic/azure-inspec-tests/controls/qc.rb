# copyright: 2018, The Authors

# Test values

resource_group1 = 'rg-example-updatemanagement'

describe azure_generic_resources(resource_group: resource_group1) do
  its('names') { should include('example-auto-acct') }
end

# describe azure_generic_resource(resource_group: resource_group1, name: 'vpn-test-basic-gw') do
#   its('properties.sku.name') { should cmp 'VpnGw1AZ' }
#   its('properties.vpnType') { should cmp 'RouteBased' } 
#   its('properties.provisioningState') { should cmp 'Succeeded' } 
#   its('properties.packetCaptureDiagnosticState') { should cmp 'None' }
#   its('properties.enablePrivateIpAddress') { should cmp 'false' }
#   its('properties.enableBgpRouteTranslationForNat') { should cmp 'false' }
#   its('properties.enableBgp') { should cmp 'false' }
#   its('properties.gatewayType') { should cmp 'Vpn' }
#   its('properties.activeActive') { should cmp 'false' }
#   its('properties.vpnGatewayGeneration')  { should cmp 'Generation1' }
#   # its('properties.ipConfigurations') { should cmp '' }
#   # its('properties.natRules') { should cmp '' }
#   # its('properties.bgpSettings') { should cmp '' }
# end