# Complete Web Application Stack Deployment

This repository contains Azure Bicep templates and ARM templates for deploying a complete web application infrastructure on Microsoft Azure, including an App Service, SQL Database, and Application Insights monitoring.

## 🏗️ Architecture Overview

The infrastructure deployment creates the following Azure resources:

- **App Service Plan** (Free tier F1)
- **Web App** (Azure App Service)
- **SQL Server** with SQL Database (Basic tier)
- **Application Insights** (Web application monitoring)
- **SQL Server Firewall Rules** (Network security)

## 📁 Repository Structure

```
├── main.json                    # Compiled ARM template (generated from Bicep)
├── main.dev.parameters.json     # Development environment parameters
├── main.stg.parameters.json     # Staging environment parameters
└── README.md                    # This file
```

## 🚀 Quick Start

### Prerequisites

- Azure CLI installed and configured
- An active Azure subscription
- Appropriate permissions to create resources in your Azure subscription
- Azure Key Vault (for development environment with SQL password)

### Deployment

#### Option 1: Using Azure CLI with Parameter Files

**Development Environment:**
```bash
az deployment group create \
  --resource-group your-resource-group \
  --template-file main.json \
  --parameters @main.dev.parameters.json
```

**Staging Environment:**
```bash
az deployment group create \
  --resource-group your-resource-group \
  --template-file main.json \
  --parameters @main.stg.parameters.json
```

#### Option 2: Using Azure Portal

1. Navigate to Azure Portal
2. Go to "Deploy a custom template"
3. Upload the `main.json` file
4. Fill in the required parameters or upload a parameter file

## 🔧 Configuration

### Environment-Specific Parameters

The repository includes parameter files for different environments:

#### Development Environment (`main.dev.parameters.json`)
- **Region**: East US (App Services), Central US (SQL)
- **Naming Convention**: `azbicep*-dev-*`
- **Security**: SQL password stored in Azure Key Vault

#### Staging Environment (`main.stg.parameters.json`)
- **Region**: East US (App Services), Central US (SQL)
- **Naming Convention**: `azbicep*-stg-*`
- **Security**: Standard configuration

### Key Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `azAppServicePlan` | Name of the App Service Plan | `azbicepappserviceplan-dev-eastus` |
| `azWebApp` | Name of the Web App | `azbicepwebapp-dev-eastus` |
| `azAppInsights` | Name of Application Insights | `azbicepappinsights-dev-eastus` |
| `azSQLserver` | Name of SQL Server | `azbicepsqlserver-dev-centralus` |
| `azSQLdb` | Name of SQL Database | `azbicepsqldb-dev-centralus` |

## 🔒 Security Considerations

### SQL Server Security
- **Development**: Password stored securely in Azure Key Vault
- **Firewall Rules**: Configured for IP range `10.2.0.1` to `10.2.0.254`
- **Admin Login**: `sqladmin` (configurable)

### Key Vault Integration (Development)
The development environment uses Azure Key Vault to securely store the SQL Server password:
```json
"azSQLloginPassword": {
    "reference": {
        "keyVault": {
            "id": "/subscriptions/.../Microsoft.KeyVault/vaults/az-dev-centralus-keyvult"
        },
        "secretName": "sqlpassword"
    }
}
```

## 📊 Monitoring

Application Insights is automatically configured and integrated with the Web App to provide:
- Application performance monitoring
- Request tracking
- Error logging
- Custom telemetry

The instrumentation key is automatically configured in the Web App's application settings.

## 🌍 Multi-Region Deployment

The template supports multi-region deployment:
- **Web Services**: East US region
- **Database Services**: Central US region

This provides geographic distribution and potential performance benefits.

## 🛠️ Customization

### Adding New Environments

1. Create a new parameter file (e.g., `main.prod.parameters.json`)
2. Update resource names following the naming convention
3. Configure environment-specific settings
4. Deploy using the new parameter file

### Modifying Resources

The main template includes nested deployments for:
- **AppServicePlan**: Web app and app service plan configuration
- **SQLserver**: Database server and database configuration
- **AppInsights**: Application monitoring setup

Each component can be modified independently within the nested templates.

## 📋 Resource Specifications

### App Service Plan
- **SKU**: F1 (Free tier)
- **Capacity**: 1 instance
- **Tier**: Free

### SQL Database
- **Edition**: Basic
- **Collation**: SQL_Latin1_General_CP1_CI_AS
- **Max Size**: 2GB
- **Service Objective**: Basic

### Application Insights
- **Type**: Web application
- **Kind**: Web

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the deployment in a development environment
5. Submit a pull request

## 🆘 Support

For issues and questions:
1. Check the Azure documentation for Bicep/ARM templates
2. Review Azure resource-specific documentation
3. Open an issue in this repository

## 🔄 CI/CD Integration

This template can be integrated with Azure DevOps, GitHub Actions, or other CI/CD pipelines for automated deployments across environments.

Example Azure DevOps pipeline task:
```yaml
- task: AzureResourceManagerTemplateDeployment@3
  inputs:
    deploymentScope: 'Resource Group'
    azureResourceManagerConnection: 'your-service-connection'
    subscriptionId: 'your-subscription-id'
    action: 'Create Or Update Resource Group'
    resourceGroupName: 'your-resource-group'
    location: 'East US'
    templateLocation: 'Linked artifact'
    csmFile: 'main.json'
    csmParametersFile: 'main.dev.parameters.json'
```
