param azAppInsights string

//Application Insights
//res-app-insi

resource azbicepappinsights 'Microsoft.Insights/components@2020-02-02' = {
  name: azAppInsights
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output oInstrumentationKey string = azbicepappinsights.properties.InstrumentationKey
