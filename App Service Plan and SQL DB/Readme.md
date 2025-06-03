## Convert Bicep into ARM Temoplate

az bicep build -f main.bicep

## Execute & Deploy resources to Azure Resource Group using the below command

az deployment group create -g <resource-group> -f <file-name> -p <parameter-file>

## Parameters Decorators

@allowed, @description, @maxLength, @metadata, @minLength, @secure, @maxValue, @minValue

## Conditional Expression - For example, you can use it to deploy in multiple env based on the condition

(param == value)? truevalue : falsevalue

## Conditional Deployments - Deploys only if condition matches

resource <resource friendly name> = if (x==y)

## List function

AccountKey=${listkeys(resource, API version)--> returns array }
AccountKey=${listKeys(StorageAccountID, '2019-06-01').keys[0].value}

## Reference function

value: reference(resource, API version).requiredvalue
value: reference(azAppInsightsId, '2015-05-01').InstrumentationKey

## Loops

module <module name> = [for Index in range(StartIndex, Count) : {reqd parameters}]
