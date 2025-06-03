targetScope = 'subscription'

resource azbicepresourcegroup 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: 'azbicep-devenv-eastus-rg1'
  location: 'eastus'
}
