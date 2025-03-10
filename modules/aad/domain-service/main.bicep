metadata name = 'Azure Active Directory Domain Services'
metadata description = 'This module deploys an Azure Active Directory Domain Services (AADDS).'
metadata owner = 'Azure/module-maintainers'

@description('Optional. The name of the AADDS resource. Defaults to the domain name specific to the Azure ADDS service.')
param name string = domainName

@description('Required. The domain name specific to the Azure ADDS service.')
param domainName string

@description('Optional. The name of the SKU specific to Azure ADDS Services.')
@allowed([
  'Standard'
  'Enterprise'
  'Premium'
])
param sku string = 'Standard'

@description('Optional. The location to deploy the Azure ADDS Services.')
param location string = resourceGroup().location

@description('Optional. Additional replica set for the managed domain.')
param replicaSets array = []

@description('Conditional. The certificate required to configure Secure LDAP. Should be a base64encoded representation of the certificate PFX file. Required if secure LDAP is enabled and must be valid more than 30 days.')
@secure()
param pfxCertificate string = ''

@description('Conditional. The password to decrypt the provided Secure LDAP certificate PFX file. Required if secure LDAP is enabled.')
@secure()
param pfxCertificatePassword string = ''

@description('Optional. The email recipient value to receive alerts.')
param additionalRecipients array = []

@description('Optional. The value is to provide domain configuration type.')
@allowed([
  'FullySynced'
  'ResourceTrusting'
])
param domainConfigurationType string = 'FullySynced'

@description('Optional. The value is to synchronize scoped users and groups.')
param filteredSync string = 'Enabled'

@description('Optional. The value is to enable clients making request using TLSv1.')
@allowed([
  'Enabled'
  'Disabled'
])
param tlsV1 string = 'Enabled'

@description('Optional. The value is to enable clients making request using NTLM v1.')
@allowed([
  'Enabled'
  'Disabled'
])
param ntlmV1 string = 'Enabled'

@description('Optional. The value is to enable synchronized users to use NTLM authentication.')
@allowed([
  'Enabled'
  'Disabled'
])
#disable-next-line secure-secrets-in-params // Not a secret
param syncNtlmPasswords string = 'Enabled'

@description('Optional. The value is to enable on-premises users to authenticate against managed domain.')
@allowed([
  'Enabled'
  'Disabled'
])
#disable-next-line secure-secrets-in-params // Not a secret
param syncOnPremPasswords string = 'Enabled'

@description('Optional. The value is to enable Kerberos requests that use RC4 encryption.')
@allowed([
  'Enabled'
  'Disabled'
])
param kerberosRc4Encryption string = 'Enabled'

@description('Optional. The value is to enable to provide a protected channel between the Kerberos client and the KDC.')
@allowed([
  'Enabled'
  'Disabled'
])
param kerberosArmoring string = 'Enabled'

@description('Optional. The value is to notify the DC Admins.')
@allowed([
  'Enabled'
  'Disabled'
])
param notifyDcAdmins string = 'Enabled'

@description('Optional. The value is to notify the Global Admins.')
@allowed([
  'Enabled'
  'Disabled'
])
param notifyGlobalAdmins string = 'Enabled'

@description('Optional. The value is to enable the Secure LDAP for external services of Azure ADDS Services.')
@allowed([
  'Enabled'
  'Disabled'
])
param externalAccess string = 'Enabled'

@description('Optional. A flag to determine whether or not Secure LDAP is enabled or disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param ldaps string = 'Enabled'

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'SystemSecurity'
  'AccountManagement'
  'LogonLogoff'
  'ObjectAccess'
  'PolicyChange'
  'PrivilegeUse'
  'DetailTracking'
  'DirectoryServiceAccess'
  'AccountLogon'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

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

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource domainService 'Microsoft.AAD/DomainServices@2021-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    domainName: domainName
    domainConfigurationType: domainConfigurationType
    filteredSync: filteredSync
    notificationSettings: {
      additionalRecipients: additionalRecipients
      notifyDcAdmins: notifyDcAdmins
      notifyGlobalAdmins: notifyGlobalAdmins
    }
    ldapsSettings: {
      externalAccess: externalAccess
      ldaps: ldaps
      pfxCertificate: !empty(pfxCertificate) ? pfxCertificate : null
      pfxCertificatePassword: !empty(pfxCertificatePassword) ? pfxCertificatePassword : null
    }
    replicaSets: replicaSets
    domainSecuritySettings: {
      tlsV1: tlsV1
      ntlmV1: ntlmV1
      syncNtlmPasswords: syncNtlmPasswords
      syncOnPremPasswords: syncOnPremPasswords
      kerberosRc4Encryption: kerberosRc4Encryption
      kerberosArmoring: kerberosArmoring
    }
    sku: sku
  }
}

resource domainService_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: '${domainService.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: domainService
}

resource domainService_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: domainService
}

resource domainService_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(domainService.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: domainService
}]

@description('The domain name of the Azure Active Directory Domain Services(Azure ADDS).')
output name string = domainService.name

@description('The name of the resource group the Azure Active Directory Domain Services(Azure ADDS) was created in.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Azure Active Directory Domain Services(Azure ADDS).')
output resourceId string = domainService.id

@description('The location the resource was deployed into.')
output location string = domainService.location

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
