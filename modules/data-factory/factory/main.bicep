metadata name = 'Data Factories'
metadata description = 'This module deploys a Data Factory.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Azure Factory to create.')
param name string

@description('Optional. The name of the Managed Virtual Network.')
param managedVirtualNetworkName string = ''

@description('Optional. An array of managed private endpoints objects created in the Data Factory managed virtual network.')
param managedPrivateEndpoints array = []

@description('Optional. An array of objects for the configuration of an Integration Runtime.')
param integrationRuntimes array = []

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. Boolean to define whether or not to configure git during template deployment.')
param gitConfigureLater bool = true

@description('Optional. Repository type - can be \'FactoryVSTSConfiguration\' or \'FactoryGitHubConfiguration\'. Default is \'FactoryVSTSConfiguration\'.')
param gitRepoType string = 'FactoryVSTSConfiguration'

@description('Optional. The account name.')
param gitAccountName string = ''

@description('Optional. The project name. Only relevant for \'FactoryVSTSConfiguration\'.')
param gitProjectName string = ''

@description('Optional. The repository name.')
param gitRepositoryName string = ''

@description('Optional. The collaboration branch name. Default is \'main\'.')
param gitCollaborationBranch string = 'main'

@description('Optional. Disable manual publish operation in ADF studio to favor automated publish.')
param gitDisablePublish bool = false

@description('Optional. The root folder path name. Default is \'/\'.')
param gitRootFolder string = '/'

@description('Optional. The GitHub Enterprise Server host (prefixed with \'https://\'). Only relevant for \'FactoryGitHubConfiguration\'.')
param gitHostName string = ''

@description('Optional. List of Global Parameters for the factory.')
param globalParameters object = {}

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Configuration Details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption.')
param cMKKeyName string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param cMKKeyVersion string = ''

@description('Conditional. User assigned identity to use when fetching the customer managed key. Required if \'cMKKeyName\' is not empty.')
param cMKUserAssignedIdentityResourceId string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'ActivityRuns'
  'PipelineRuns'
  'TriggerRuns'
  'SSISPackageEventMessages'
  'SSISPackageExecutableStatistics'
  'SSISPackageEventMessageContext'
  'SSISPackageExecutionComponentPhases'
  'SSISPackageExecutionDataStatistics'
  'SSISIntegrationRuntimeLogs'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs' && item != ''): {
  category: category
  enabled: true
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
  }
] : contains(diagnosticLogCategoriesToEnable, '') ? [] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
}]

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Data Factory Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '673868aa-7521-48a0-acc6-0f60742d39f5')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : 'dummyVault'), '/'))!
  scope: resourceGroup(split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : '//'), '/')[2], split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : '////'), '/')[4])
}

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

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    repoConfiguration: bool(gitConfigureLater) ? null : union({
        type: gitRepoType
        hostName: gitHostName
        accountName: gitAccountName
        repositoryName: gitRepositoryName
        collaborationBranch: gitCollaborationBranch
        rootFolder: gitRootFolder
        disablePublish: gitDisablePublish
      }, (gitRepoType == 'FactoryVSTSConfiguration' ? {
        projectName: gitProjectName
      } : {}), {})
    globalParameters: !empty(globalParameters) ? globalParameters : null
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) ? 'Disabled' : null)
    encryption: !empty(cMKKeyName) ? {
      identity: {
        userAssignedIdentity: cMKUserAssignedIdentityResourceId
      }
      keyName: cMKKeyName
      keyVersion: !empty(cMKKeyVersion) ? cMKKeyVersion : null
      vaultBaseUrl: cMKKeyVault.properties.vaultUri
    } : null
  }
}

module dataFactory_managedVirtualNetwork 'managed-virtual-network/main.bicep' = if (!empty(managedVirtualNetworkName)) {
  name: '${uniqueString(deployment().name, location)}-DataFactory-ManagedVNet'
  params: {
    name: managedVirtualNetworkName
    dataFactoryName: dataFactory.name
    managedPrivateEndpoints: managedPrivateEndpoints
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module dataFactory_integrationRuntimes 'integration-runtime/main.bicep' = [for (integrationRuntime, index) in integrationRuntimes: {
  name: '${uniqueString(deployment().name, location)}-DataFactory-IntegrationRuntime-${index}'
  params: {
    dataFactoryName: dataFactory.name
    name: integrationRuntime.name
    type: integrationRuntime.type
    managedVirtualNetworkName: contains(integrationRuntime, 'managedVirtualNetworkName') ? integrationRuntime.managedVirtualNetworkName : ''
    typeProperties: contains(integrationRuntime, 'typeProperties') ? integrationRuntime.typeProperties : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    dataFactory_managedVirtualNetwork
  ]
}]

resource dataFactory_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: dataFactory
}

resource dataFactory_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: dataFactory
}

resource dataFactory_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(dataFactory.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: dataFactory
}]

module dataFactory_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}-dataFactory-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.?service ?? 'dataFactory'
    ]
    name: privateEndpoint.?name ?? 'pep-${last(split(dataFactory.id, '/'))}-${privateEndpoint.?service ?? 'dataFactory'}-${index}'
    serviceResourceId: dataFactory.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: privateEndpoint.?enableDefaultTelemetry ?? enableReferencedModulesTelemetry
    location: privateEndpoint.?location ?? reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
    privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
    roleAssignments: privateEndpoint.?roleAssignments
    tags: privateEndpoint.?tags ?? tags
    manualPrivateLinkServiceConnections: privateEndpoint.?manualPrivateLinkServiceConnections
    customDnsConfigs: privateEndpoint.?customDnsConfigs
    ipConfigurations: privateEndpoint.?ipConfigurations
    applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
    customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
  }
}]

@description('The Name of the Azure Data Factory instance.')
output name string = dataFactory.name

@description('The Resource ID of the Data factory.')
output resourceId string = dataFactory.id

@description('The name of the Resource Group with the Data factory.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(dataFactory.identity, 'principalId') ? dataFactory.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = dataFactory.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device' | null)?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    fqdn: string?
    ipAddresses: string[]
  }[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    name: string
    groupId: string
    memberName: string
    privateIpAddress: string
  }[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType

  @description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Manual PrivateLink Service Connections.')
  manualPrivateLinkServiceConnections: array?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?
}[]?
