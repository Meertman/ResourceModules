metadata name = 'Deployment Scripts'
metadata description = 'This module deploys a Deployment Script.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Display name of the script to be run.')
param name string

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Type of the script. AzurePowerShell, AzureCLI.')
@allowed([
  'AzurePowerShell'
  'AzureCLI'
])
param kind string = 'AzurePowerShell'

@description('Optional. Azure PowerShell module version to be used.')
param azPowerShellVersion string = '3.0'

@description('Optional. Azure CLI module version to be used.')
param azCliVersion string = ''

@description('Optional. Script body. Max length: 32000 characters. To run an external script, use primaryScriptURI instead.')
param scriptContent string = ''

@description('Optional. Uri for the external script. This is the entry point for the external script. To run an internal script, use the scriptContent instead.')
param primaryScriptUri string = ''

@description('Optional. The environment variables to pass over to the script. The list is passed as an object with a key name "secureList" and the value is the list of environment variables (array). The list must have a \'name\' and a \'value\' or a \'secretValue\' property for each object.')
@secure()
param environmentVariables object = {}

@description('Optional. List of supporting files for the external script (defined in primaryScriptUri). Does not work with internal scripts (code defined in scriptContent).')
param supportingScriptUris array = []

@description('Optional. Command-line arguments to pass to the script. Arguments are separated by spaces.')
param arguments string = ''

@description('Optional. Interval for which the service retains the script resource after it reaches a terminal state. Resource will be deleted when this duration expires. Duration is based on ISO 8601 pattern (for example P7D means one week).')
param retentionInterval string = 'P1D'

@description('Optional. When set to false, script will run every time the template is deployed. When set to true, the script will only run once.')
param runOnce bool = false

@description('Optional. The clean up preference when the script execution gets in a terminal state. Specify the preference on when to delete the deployment script resources. The default value is Always, which means the deployment script resources are deleted despite the terminal state (Succeeded, Failed, canceled).')
@allowed([
  'Always'
  'OnSuccess'
  'OnExpiration'
])
param cleanupPreference string = 'Always'

@description('Optional. Container group name, if not specified then the name will get auto-generated. Not specifying a \'containerGroupName\' indicates the system to generate a unique name which might end up flagging an Azure Policy as non-compliant. Use \'containerGroupName\' when you have an Azure Policy that expects a specific naming convention or when you want to fully control the name. \'containerGroupName\' property must be between 1 and 63 characters long, must contain only lowercase letters, numbers, and dashes and it cannot start or end with a dash and consecutive dashes are not allowed.')
param containerGroupName string = ''

@description('Optional. The resource ID of the storage account to use for this deployment script. If none is provided, the deployment script uses a temporary, managed storage account.')
param storageAccountResourceId string = ''

@description('Optional. Maximum allowed script execution time specified in ISO 8601 format. Default value is PT1H - 1 hour; \'PT30M\' - 30 minutes; \'P5D\' - 5 days; \'P1Y\' 1 year.')
param timeout string = 'PT1H'

@description('Generated. Do not provide a value! This date value is used to make sure the script run every time the template is deployed.')
param baseTime string = utcNow('yyyy-MM-dd-HH-mm-ss')

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var containerSettings = {
  containerGroupName: containerGroupName
}

var identityType = !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var storageAccountSettings = !empty(storageAccountResourceId) ? {
  storageAccountKey: listKeys(storageAccountResourceId, '2019-06-01').keys[0].value
  storageAccountName: last(split(storageAccountResourceId, '/'))
} : {}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  kind: any(kind)
  properties: {
    azPowerShellVersion: kind == 'AzurePowerShell' ? azPowerShellVersion : null
    azCliVersion: kind == 'AzureCLI' ? azCliVersion : null
    containerSettings: !empty(containerGroupName) ? containerSettings : null
    storageAccountSettings: !empty(storageAccountResourceId) ? storageAccountSettings : null
    arguments: arguments
    environmentVariables: !empty(environmentVariables) ? environmentVariables.secureList : []
    scriptContent: !empty(scriptContent) ? scriptContent : null
    primaryScriptUri: !empty(primaryScriptUri) ? primaryScriptUri : null
    supportingScriptUris: !empty(supportingScriptUris) ? supportingScriptUris : null
    cleanupPreference: cleanupPreference
    forceUpdateTag: runOnce ? resourceGroup().name : baseTime
    retentionInterval: retentionInterval
    timeout: timeout
  }
}

resource deploymentScript_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: deploymentScript
}

@description('The resource ID of the deployment script.')
output resourceId string = deploymentScript.id

@description('The resource group the deployment script was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the deployment script.')
output name string = deploymentScript.name

@description('The location the resource was deployed into.')
output location string = deploymentScript.location

@description('The output of the deployment script.')
output outputs object = contains(deploymentScript.properties, 'outputs') ? deploymentScript.properties.outputs : {}

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?
