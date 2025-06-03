param azAppServicePlan string
param azWebApp string
param azInstrumentationKey string
@description('Only the mentioned SKUs are allowed to be deployed')
@allowed(['F1', 'B1', 'B2', 'B3', 'S1', 'S2', 'S3'])
param azSKUName string
@minValue(1) //example
@maxValue(30) //example
param azSKUCapacity int
param azEnv string

//res-plan

resource azbicepapp 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: azAppServicePlan
  location: resourceGroup().location
  sku: {
    name: azSKUName
    capacity: azSKUCapacity
  }
}

// resource azbicepapp2 'Microsoft.Web/serverfarms@2020-12-01' = {
//   name: 'azbicepappserviceplan-dev-linux-centralus'
//   kind: 'linux'
//   properties: {
//     reserved: true
//   }
//   location: resourceGroup().location
//   sku: {
//     name: 'S1'
//     capacity: 1
//   }
// }

//For some reason, I'm not able to create 2 app service plans with free tier in same region

//WebApp

//res-web-app

resource webApplication 'Microsoft.Web/sites@2021-01-15' = {
  name: azWebApp
  location: resourceGroup().location
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', azAppServicePlan) //serverFarmId is the ID of app service plan, resourceId gives the ID of any service: it accepts 2 parameters; provider name and service name
  }
  //If the deployment depends on another deployment

  dependsOn: [
    azbicepapp
  ]
}

resource WebAppSlot 'Microsoft.Web/sites/slots@2024-04-01' = if (azEnv == 'prod') {
  name: 'staging'
  location: resourceGroup().location
  parent: webApplication
  properties: {
    serverFarmId: azbicepapp.id
  }
}

//Application settings in WebApp - key-value pairs that configure the behavior of the application.
//To link App insights with WebApp

resource azwebappsettings 'Microsoft.Web/sites/config@2024-04-01' = {
  name: 'web'
  parent: webApplication
  properties: {
    appSettings: [
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: azInstrumentationKey
      }
      // {
      //   name: 'key2'
      //   value: 'value2'
      // }
    ]
  }
}
