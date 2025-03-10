metadata name = 'Recovery Services Vaults'
metadata description = 'This module deploys a Recovery Services Vault.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Azure Recovery Service Vault.')
param name string

@description('Optional. The storage configuration for the Azure Recovery Service Vault.')
param backupStorageConfig object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. List of all backup policies.')
param backupPolicies array = []

@description('Optional. The backup configuration.')
param backupConfig object = {}

@description('Optional. List of all protection containers.')
@minLength(0)
param protectionContainers array = []

@description('Optional. List of all replication fabrics.')
@minLength(0)
param replicationFabrics array = []

@description('Optional. List of all replication policies.')
@minLength(0)
param replicationPolicies array = []

@description('Optional. Replication alert settings.')
param replicationAlertSettings object = {}

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Tags of the Recovery Service Vault resource.')
param tags object = {}

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'AzureBackupReport'
  'CoreAzureBackup'
  'AddonAzureBackupJobs'
  'AddonAzureBackupAlerts'
  'AddonAzureBackupPolicy'
  'AddonAzureBackupStorage'
  'AddonAzureBackupProtectedInstance'
  'AzureSiteRecoveryJobs'
  'AzureSiteRecoveryEvents'
  'AzureSiteRecoveryReplicatedItems'
  'AzureSiteRecoveryReplicationStats'
  'AzureSiteRecoveryRecoveryPoints'
  'AzureSiteRecoveryReplicationDataUploadRate'
  'AzureSiteRecoveryProtectedDiskDataChurn'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'Health'
])
param diagnosticMetricsToEnable array = [
  'Health'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. Monitoring Settings of the vault.')
param monitoringSettings object = {}

@description('Optional. Security Settings of the vault.')
param securitySettings object = {}

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

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
  'Backup Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e467623-bb1f-42f4-a55d-6e525e11384b')
  'Backup Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00c29273-979b-4161-815c-10b084fb9324')
  'Backup Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a795c7a0-d4a2-40c1-ae25-d81f01202912')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'Site Recovery Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6670b86e-a3f7-4917-ac9b-5d6ab1be4567')
  'Site Recovery Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '494ae006-db33-4328-bf46-533a6560a3ca')
  'Site Recovery Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'dbaa88c4-0c30-4179-9fb3-46319faa6149')
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

resource rsv 'Microsoft.RecoveryServices/vaults@2023-01-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    monitoringSettings: !empty(monitoringSettings) ? monitoringSettings : null
    securitySettings: !empty(securitySettings) ? securitySettings : null
    publicNetworkAccess: publicNetworkAccess
  }
}

module rsv_replicationFabrics 'replication-fabric/main.bicep' = [for (replicationFabric, index) in replicationFabrics: {
  name: '${uniqueString(deployment().name, location)}-RSV-Fabric-${index}'
  params: {
    recoveryVaultName: rsv.name
    name: contains(replicationFabric, 'name') ? replicationFabric.name : replicationFabric.location
    location: replicationFabric.location
    replicationContainers: contains(replicationFabric, 'replicationContainers') ? replicationFabric.replicationContainers : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    rsv_replicationPolicies
  ]
}]

module rsv_replicationPolicies 'replication-policy/main.bicep' = [for (replicationPolicy, index) in replicationPolicies: {
  name: '${uniqueString(deployment().name, location)}-RSV-Policy-${index}'
  params: {
    name: replicationPolicy.name
    recoveryVaultName: rsv.name
    appConsistentFrequencyInMinutes: contains(replicationPolicy, 'appConsistentFrequencyInMinutes') ? replicationPolicy.appConsistentFrequencyInMinutes : 60
    crashConsistentFrequencyInMinutes: contains(replicationPolicy, 'crashConsistentFrequencyInMinutes') ? replicationPolicy.crashConsistentFrequencyInMinutes : 5
    multiVmSyncStatus: contains(replicationPolicy, 'multiVmSyncStatus') ? replicationPolicy.multiVmSyncStatus : 'Enable'
    recoveryPointHistory: contains(replicationPolicy, 'recoveryPointHistory') ? replicationPolicy.recoveryPointHistory : 1440
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module rsv_backupStorageConfiguration 'backup-storage-config/main.bicep' = if (!empty(backupStorageConfig)) {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupStorageConfig'
  params: {
    recoveryVaultName: rsv.name
    storageModelType: backupStorageConfig.storageModelType
    crossRegionRestoreFlag: backupStorageConfig.crossRegionRestoreFlag
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module rsv_backupFabric_protectionContainers 'backup-fabric/protection-container/main.bicep' = [for (protectionContainer, index) in protectionContainers: {
  name: '${uniqueString(deployment().name, location)}-RSV-ProtectionContainers-${index}'
  params: {
    recoveryVaultName: rsv.name
    name: protectionContainer.name
    sourceResourceId: protectionContainer.sourceResourceId
    friendlyName: protectionContainer.friendlyName
    backupManagementType: protectionContainer.backupManagementType
    containerType: protectionContainer.containerType
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    protectedItems: contains(protectionContainer, 'protectedItems') ? protectionContainer.protectedItems : []
    location: location
  }
}]

module rsv_backupPolicies 'backup-policy/main.bicep' = [for (backupPolicy, index) in backupPolicies: {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupPolicy-${index}'
  params: {
    recoveryVaultName: rsv.name
    name: backupPolicy.name
    properties: backupPolicy.properties
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module rsv_backupConfig 'backup-config/main.bicep' = if (!empty(backupConfig)) {
  name: '${uniqueString(deployment().name, location)}-RSV-BackupConfig'
  params: {
    recoveryVaultName: rsv.name
    name: contains(backupConfig, 'name') ? backupConfig.name : 'vaultconfig'
    enhancedSecurityState: contains(backupConfig, 'enhancedSecurityState') ? backupConfig.enhancedSecurityState : 'Enabled'
    resourceGuardOperationRequests: contains(backupConfig, 'resourceGuardOperationRequests') ? backupConfig.resourceGuardOperationRequests : []
    softDeleteFeatureState: contains(backupConfig, 'softDeleteFeatureState') ? backupConfig.softDeleteFeatureState : 'Enabled'
    storageModelType: contains(backupConfig, 'storageModelType') ? backupConfig.storageModelType : 'GeoRedundant'
    storageType: contains(backupConfig, 'storageType') ? backupConfig.storageType : 'GeoRedundant'
    storageTypeState: contains(backupConfig, 'storageTypeState') ? backupConfig.storageTypeState : 'Locked'
    isSoftDeleteFeatureStateEditable: contains(backupConfig, 'isSoftDeleteFeatureStateEditable') ? backupConfig.isSoftDeleteFeatureStateEditable : true
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module rsv_replicationAlertSettings 'replication-alert-setting/main.bicep' = if (!empty(replicationAlertSettings)) {
  name: '${uniqueString(deployment().name, location)}-RSV-replicationAlertSettings'
  params: {
    name: 'defaultAlertSetting'
    recoveryVaultName: rsv.name
    customEmailAddresses: contains(replicationAlertSettings, 'customEmailAddresses') ? replicationAlertSettings.customEmailAddresses : []
    locale: contains(replicationAlertSettings, 'locale') ? replicationAlertSettings.locale : ''
    sendToOwners: contains(replicationAlertSettings, 'sendToOwners') ? replicationAlertSettings.sendToOwners : 'Send'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

resource rsv_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: rsv
}

resource rsv_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: rsv
}

module rsv_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}-rsv-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.?service ?? 'AzureSiteRecovery'
    ]
    name: privateEndpoint.?name ?? 'pep-${last(split(rsv.id, '/'))}-${privateEndpoint.?service ?? 'AzureSiteRecovery'}-${index}'
    serviceResourceId: rsv.id
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

resource rsv_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(rsv.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: rsv
}]

@description('The resource ID of the recovery services vault.')
output resourceId string = rsv.id

@description('The name of the resource group the recovery services vault was created in.')
output resourceGroupName string = resourceGroup().name

@description('The Name of the recovery services vault.')
output name string = rsv.name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(rsv.identity, 'principalId') ? rsv.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = rsv.location

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
