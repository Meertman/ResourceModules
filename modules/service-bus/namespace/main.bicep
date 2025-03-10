metadata name = 'Service Bus Namespaces'
metadata description = 'This module deploys a Service Bus Namespace.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Service Bus Namespace.')
@maxLength(50)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Name of this SKU. - Basic, Standard, Premium.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string = 'Basic'

@description('Optional. The specified messaging units for the tier. Only used for Premium Sku tier.')
@allowed([
  1
  2
  4
  8
  16
  32
])
param skuCapacity int = 1

@description('Optional. Enabling this property creates a Premium Service Bus Namespace in regions supported availability zones.')
param zoneRedundant bool = false

@allowed([
  '1.0'
  '1.1'
  '1.2'
])
@description('Optional. The minimum TLS version for the cluster to support.')
param minimumTlsVersion string = '1.2'

@description('Optional. Alternate name for namespace.')
param alternateName string = ''

@description('Optional. The number of partitions of a Service Bus namespace. This property is only applicable to Premium SKU namespaces. The default value is 1 and possible values are 1, 2 and 4.')
param premiumMessagingPartitions int = 1

@description('Optional. Authorization Rules for the Service Bus namespace.')
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

@description('Optional. The migration configuration.')
param migrationConfigurations object = {}

@description('Optional. The disaster recovery configuration.')
param disasterRecoveryConfigs object = {}

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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Disabled'
  'Enabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = ''

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. Configure networking options for Premium SKU Service Bus. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace.')
param networkRuleSets object = {}

@description('Optional. This property disables SAS authentication for the Service Bus namespace.')
param disableLocalAuth bool = true

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The queues to create in the service bus namespace.')
param queues array = []

@description('Optional. The topics to create in the service bus namespace.')
param topics array = []

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption. If not provided, encryption is automatically enabled with a Microsoft-managed key.')
param cMKKeyName string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param cMKKeyVersion string = ''

@description('Optional. User assigned identity to use when fetching the customer managed key. If not provided, a system-assigned identity can be used - but must be given access to the referenced key vault first.')
param cMKUserAssignedIdentityResourceId string = ''

@description('Optional. Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.')
param requireInfrastructureEncryption bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'OperationalLogs'
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

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  'Azure Service Bus Data Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '090c5cfd-751d-490a-894a-3ce6f1109419')
  'Azure Service Bus Data Receiver': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0')
  'Azure Service Bus Data Sender': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39')
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : 'dummyVault'), '/'))!
  scope: resourceGroup(split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : '//'), '/')[2], split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : '////'), '/')[4])

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(cMKKeyName)) {
    name: !empty(cMKKeyName) ? cMKKeyName : 'dummyKey'
  }
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: name
  location: location
  tags: empty(tags) ? null : tags
  sku: {
    name: skuName
    capacity: skuName == 'Premium' ? skuCapacity : null
  }
  identity: identity
  properties: {
    publicNetworkAccess: !empty(publicNetworkAccess) ? publicNetworkAccess : (!empty(privateEndpoints) && empty(networkRuleSets) ? 'Disabled' : 'Enabled')
    minimumTlsVersion: minimumTlsVersion
    alternateName: !empty(alternateName) ? alternateName : null
    zoneRedundant: zoneRedundant
    disableLocalAuth: disableLocalAuth
    premiumMessagingPartitions: skuName == 'Premium' ? premiumMessagingPartitions : 0
    encryption: !empty(cMKKeyName) ? {
      keySource: 'Microsoft.KeyVault'
      keyVaultProperties: [
        {
          identity: !empty(cMKUserAssignedIdentityResourceId) ? {
            userAssignedIdentity: cMKUserAssignedIdentityResourceId
          } : null
          keyName: cMKKeyName
          keyVaultUri: cMKKeyVault.properties.vaultUri
          keyVersion: !empty(cMKKeyVersion) ? cMKKeyVersion : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
        }
      ]
      requireInfrastructureEncryption: requireInfrastructureEncryption
    } : null
  }
}

module serviceBusNamespace_authorizationRules 'authorization-rule/main.bicep' = [for (authorizationRule, index) in authorizationRules: {
  name: '${uniqueString(deployment().name, location)}-AuthorizationRules-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: authorizationRule.name
    rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module serviceBusNamespace_disasterRecoveryConfig 'disaster-recovery-config/main.bicep' = if (!empty(disasterRecoveryConfigs)) {
  name: '${uniqueString(deployment().name, location)}-DisasterRecoveryConfig'
  params: {
    namespaceName: serviceBusNamespace.name
    name: contains(disasterRecoveryConfigs, 'name') ? disasterRecoveryConfigs.name : 'default'
    alternateName: contains(disasterRecoveryConfigs, 'alternateName') ? disasterRecoveryConfigs.alternateName : ''
    partnerNamespaceResourceID: contains(disasterRecoveryConfigs, 'partnerNamespace') ? disasterRecoveryConfigs.partnerNamespace : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module serviceBusNamespace_migrationConfigurations 'migration-configuration/main.bicep' = if (!empty(migrationConfigurations)) {
  name: '${uniqueString(deployment().name, location)}-MigrationConfigurations'
  params: {
    namespaceName: serviceBusNamespace.name
    postMigrationName: migrationConfigurations.postMigrationName
    targetNamespaceResourceId: migrationConfigurations.targetNamespace
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module serviceBusNamespace_networkRuleSet 'network-rule-set/main.bicep' = if (!empty(networkRuleSets) || !empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-NetworkRuleSet'
  params: {
    namespaceName: serviceBusNamespace.name
    publicNetworkAccess: contains(networkRuleSets, 'publicNetworkAccess') ? networkRuleSets.publicNetworkAccess : (!empty(privateEndpoints) && empty(networkRuleSets) ? 'Disabled' : 'Enabled')
    defaultAction: contains(networkRuleSets, 'defaultAction') ? networkRuleSets.defaultAction : 'Allow'
    trustedServiceAccessEnabled: contains(networkRuleSets, 'trustedServiceAccessEnabled') ? networkRuleSets.trustedServiceAccessEnabled : true
    ipRules: contains(networkRuleSets, 'ipRules') ? networkRuleSets.ipRules : []
    virtualNetworkRules: contains(networkRuleSets, 'virtualNetworkRules') ? networkRuleSets.virtualNetworkRules : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module serviceBusNamespace_queues 'queue/main.bicep' = [for (queue, index) in queues: {
  name: '${uniqueString(deployment().name, location)}-Queue-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: queue.name
    autoDeleteOnIdle: contains(queue, 'autoDeleteOnIdle') ? queue.autoDeleteOnIdle : ''
    forwardDeadLetteredMessagesTo: contains(queue, 'forwardDeadLetteredMessagesTo') ? queue.forwardDeadLetteredMessagesTo : ''
    forwardTo: contains(queue, 'forwardTo') ? queue.forwardTo : ''
    maxMessageSizeInKilobytes: contains(queue, 'maxMessageSizeInKilobytes') ? queue.maxMessageSizeInKilobytes : 1024
    authorizationRules: contains(queue, 'authorizationRules') ? queue.authorizationRules : [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
    ]
    deadLetteringOnMessageExpiration: contains(queue, 'deadLetteringOnMessageExpiration') ? queue.deadLetteringOnMessageExpiration : true
    defaultMessageTimeToLive: contains(queue, 'defaultMessageTimeToLive') ? queue.defaultMessageTimeToLive : 'P14D'
    duplicateDetectionHistoryTimeWindow: contains(queue, 'duplicateDetectionHistoryTimeWindow') ? queue.duplicateDetectionHistoryTimeWindow : 'PT10M'
    enableBatchedOperations: contains(queue, 'enableBatchedOperations') ? queue.enableBatchedOperations : true
    enableExpress: contains(queue, 'enableExpress') ? queue.enableExpress : false
    enablePartitioning: contains(queue, 'enablePartitioning') ? queue.enablePartitioning : false
    lock: queue.?lock ?? lock
    lockDuration: contains(queue, 'lockDuration') ? queue.lockDuration : 'PT1M'
    maxDeliveryCount: contains(queue, 'maxDeliveryCount') ? queue.maxDeliveryCount : 10
    maxSizeInMegabytes: contains(queue, 'maxSizeInMegabytes') ? queue.maxSizeInMegabytes : 1024
    requiresDuplicateDetection: contains(queue, 'requiresDuplicateDetection') ? queue.requiresDuplicateDetection : false
    requiresSession: contains(queue, 'requiresSession') ? queue.requiresSession : false
    roleAssignments: contains(queue, 'roleAssignments') ? queue.roleAssignments : []
    status: contains(queue, 'status') ? queue.status : 'Active'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module serviceBusNamespace_topics 'topic/main.bicep' = [for (topic, index) in topics: {
  name: '${uniqueString(deployment().name, location)}-Topic-${index}'
  params: {
    namespaceName: serviceBusNamespace.name
    name: topic.name
    authorizationRules: contains(topic, 'authorizationRules') ? topic.authorizationRules : [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
    ]
    autoDeleteOnIdle: contains(topic, 'autoDeleteOnIdle') ? topic.autoDeleteOnIdle : 'PT5M'
    defaultMessageTimeToLive: contains(topic, 'defaultMessageTimeToLive') ? topic.defaultMessageTimeToLive : 'P14D'
    duplicateDetectionHistoryTimeWindow: contains(topic, 'duplicateDetectionHistoryTimeWindow') ? topic.duplicateDetectionHistoryTimeWindow : 'PT10M'
    enableBatchedOperations: contains(topic, 'enableBatchedOperations') ? topic.enableBatchedOperations : true
    enableExpress: contains(topic, 'enableExpress') ? topic.enableExpress : false
    enablePartitioning: contains(topic, 'enablePartitioning') ? topic.enablePartitioning : false
    lock: topic.?lock ?? lock
    maxMessageSizeInKilobytes: contains(topic, 'maxMessageSizeInKilobytes') ? topic.maxMessageSizeInKilobytes : 1024
    maxSizeInMegabytes: contains(topic, 'maxSizeInMegabytes') ? topic.maxSizeInMegabytes : 1024
    requiresDuplicateDetection: contains(topic, 'requiresDuplicateDetection') ? topic.requiresDuplicateDetection : false
    roleAssignments: contains(topic, 'roleAssignments') ? topic.roleAssignments : []
    status: contains(topic, 'status') ? topic.status : 'Active'
    supportOrdering: contains(topic, 'supportOrdering') ? topic.supportOrdering : false
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource serviceBusNamespace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: serviceBusNamespace
}

resource serviceBusNamespace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: serviceBusNamespace
}

module serviceBusNamespace_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}-serviceBusNamespace-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.?service ?? 'namespace'
    ]
    name: privateEndpoint.?name ?? 'pep-${last(split(serviceBusNamespace.id, '/'))}-${privateEndpoint.?service ?? 'namespace'}-${index}'
    serviceResourceId: serviceBusNamespace.id
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

resource serviceBusNamespace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(serviceBusNamespace.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: serviceBusNamespace
}]

@description('The resource ID of the deployed service bus namespace.')
output resourceId string = serviceBusNamespace.id

@description('The resource group of the deployed service bus namespace.')
output resourceGroupName string = resourceGroup().name

@description('The name of the deployed service bus namespace.')
output name string = serviceBusNamespace.name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(serviceBusNamespace.identity, 'principalId') ? serviceBusNamespace.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = serviceBusNamespace.location

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
