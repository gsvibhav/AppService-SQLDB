param azSQLserver string
param azSQLdb string
param azSQLlogin string
@secure()
param azSQLloginPassword string

//res-sql

resource sqlServer 'Microsoft.Sql/servers@2014-04-01' = {
  name: azSQLserver
  location: resourceGroup().location
  properties: {
    administratorLogin: azSQLlogin
    administratorLoginPassword: azSQLloginPassword
  }
}

//res-sql-server-firewall-rules

resource sqlServerFirewallRules 'Microsoft.Sql/servers/firewallRules@2021-02-01-preview' = {
  parent: sqlServer
  name: 'sqlconnectionfirewallrule'
  properties: {
    startIpAddress: '10.2.0.1'
    endIpAddress: '10.2.0.254'
  }
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2014-04-01' = {
  parent: sqlServer
  name: azSQLdb
  location: resourceGroup().location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    edition: 'Basic'
    maxSizeBytes: '2147483648'
    requestedServiceObjectiveName: 'Basic'
  }
}
