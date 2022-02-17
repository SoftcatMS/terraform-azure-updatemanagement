# copyright: 2018, The Authors

# Test values

resource_group1 = 'rg-test-updatemanagement'

describe azure_generic_resources(resource_group: resource_group1) do
  its('names') { should include('test-auto-acct') }
end

describe azure_generic_resources(resource_group: resource_group1) do
  its('names') { should include('test-log-workspace') }
end