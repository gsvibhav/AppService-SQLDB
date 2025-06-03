param Env string = 'dev'
param azAppServicePlan string
param azWebApp string
param azAppInsights string
param azSQLserver string
param azSQLdb string
param azSQLlogin string
@secure()
param azSQLloginPassword string
param azSKUName string = (Env == 'dev') ? 'F1' : 'S1'
param azSKUCapacity int = (Env == 'dev') ? 2 : 3 //Not needed in production

resource KeyVault1 'Microsoft.KeyVault/vaults@2024-12-01-preview' existing = {
  name: 'az-dev-centralus-keyvult'
}

module AppServicePlan 'appserviceplan.bicep' = {
  name: 'AppServicePlan'
  params: {
    azInstrumentationKey: AppInsights.outputs.oInstrumentationKey
    azAppServicePlan: azAppServicePlan
    azWebApp: azWebApp
    azSKUName: azSKUName
    azSKUCapacity: azSKUCapacity
    azEnv: Env
  }
}

module SQLserver 'sqldb.bicep' = {
  name: 'SQLserver'
  params: {
    azSQLdb: azSQLdb
    azSQLserver: azSQLserver
    azSQLlogin: azSQLlogin
    azSQLloginPassword: KeyVault1.getSecret('sqlpassword')
  }
}

module AppInsights 'appinsights.bicep' = {
  name: 'AppInsights'
  params: {
    azAppInsights: azAppInsights
  }
}
