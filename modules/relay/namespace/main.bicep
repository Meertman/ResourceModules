metadata name = 'Relay Namespaces'
metadata description = 'This module deploys a Relay Namespace'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Relay Namespace.')
@minLength(6)
@maxLength(50)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Name of this SKU.')
@allowed([
  'Standard'
])
param skuName string = 'Standard'

@description('Optional. Authorization Rules for the Relay namespace.')
param authorizationRules array = [
  {
    name: 'RootManageSharedAccessKey'
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
]

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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. Configure networking options for Relay. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace.')
param networkRuleSets object = {}

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The hybrid connections to create in the relay namespace.')
param hybridConnections array = []

@description('Optional. The wcf relays to create in the relay namespace.')
param wcfRelays array = []

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'OperationalLogs'
  'hybridConnectionsEvent'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
  'hybridConnectionsEvent'
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

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  'Azure Relay Listener': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '26e0b698-aa6d-4085-9386-aadae190014d')
  'Azure Relay Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2787bf04-f1f5-4bfe-8383-c8a24483ee38')
  'Azure Relay Sender': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '26baccc8-eea7-41f1-98f4-1762cc7f685d')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
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

resource namespace 'Microsoft.Relay/namespaces@2021-11-01' = {
  name: name
  location: location
  tags: empty(tags) ? null : tags
  sku: {
    name: skuName
  }
  properties: {}
}

module namespace_authorizationRules 'authorization-rule/main.bicep' = [for (authorizationRule, index) in authorizationRules: {
  name: '${uniqueString(deployment().name, location)}-AuthorizationRules-${index}'
  params: {
    namespaceName: namespace.name
    name: authorizationRule.name
    rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module namespace_networkRuleSet 'network-rule-set/main.bicep' = if (!empty(networkRuleSets) || !empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-NetworkRuleSet'
  params: {
    namespaceName: namespace.name
    publicNetworkAccess: contains(networkRuleSets, 'publicNetworkAccess') ? networkRuleSets.publicNetworkAccess : (!empty(privateEndpoints) && empty(networkRuleSets) ? 'Disabled' : 'Enabled')
    defaultAction: contains(networkRuleSets, 'defaultAction') ? networkRuleSets.defaultAction : 'Allow'
    ipRules: contains(networkRuleSets, 'ipRules') ? networkRuleSets.ipRules : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module namespace_hybridConnections 'hybrid-connection/main.bicep' = [for (hybridConnection, index) in hybridConnections: {
  name: '${uniqueString(deployment().name, location)}-HybridConnection-${index}'
  params: {
    namespaceName: namespace.name
    name: hybridConnection.name
    authorizationRules: contains(hybridConnection, 'authorizationRules') ? hybridConnection.authorizationRules : [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
      {
        name: 'defaultListener'
        rights: [
          'Listen'
        ]
      }
      {
        name: 'defaultSender'
        rights: [
          'Send'
        ]
      }
    ]
    requiresClientAuthorization: contains(hybridConnection, 'requiresClientAuthorization') ? hybridConnection.requiresClientAuthorization : true
    userMetadata: hybridConnection.userMetadata
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module namespace_wcfRelays 'wcf-relay/main.bicep' = [for (wcfRelay, index) in wcfRelays: {
  name: '${uniqueString(deployment().name, location)}-WcfRelay-${index}'
  params: {
    namespaceName: namespace.name
    name: wcfRelay.name
    authorizationRules: contains(wcfRelay, 'authorizationRules') ? wcfRelay.authorizationRules : [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
      {
        name: 'defaultListener'
        rights: [
          'Listen'
        ]
      }
      {
        name: 'defaultSender'
        rights: [
          'Send'
        ]
      }
    ]
    relayType: wcfRelay.relayType
    requiresClientAuthorization: contains(wcfRelay, 'requiresClientAuthorization') ? wcfRelay.requiresClientAuthorization : true
    requiresTransportSecurity: contains(wcfRelay, 'requiresTransportSecurity') ? wcfRelay.requiresTransportSecurity : true
    userMetadata: contains(wcfRelay, 'userMetadata') ? wcfRelay.userMetadata : null
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource namespace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: namespace
}

resource namespace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: namespace
}

module namespace_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}-namespace-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.?service ?? 'namespace'
    ]
    name: privateEndpoint.?name ?? 'pep-${last(split(namespace.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
    serviceResourceId: namespace.id
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

resource namespace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(namespace.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: namespace
}]

@description('The resource ID of the deployed relay namespace.')
output resourceId string = namespace.id

@description('The resource group of the deployed relay namespace.')
output resourceGroupName string = resourceGroup().name

@description('The name of the deployed relay namespace.')
output name string = namespace.name

@description('The location the resource was deployed into.')
output location string = namespace.location

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
