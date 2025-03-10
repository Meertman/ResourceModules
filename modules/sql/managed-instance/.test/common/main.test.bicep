targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.managedinstances-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlmicom'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep${namePrefix}kv${serviceShort}${substring(uniqueString(baseTime), 0, 3)}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    routeTableName: 'dep-${namePrefix}-rt-${serviceShort}'
    location: location
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/.templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}azsa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}-${serviceShort}'
    administratorLogin: 'adminUserName'
    administratorLoginPassword: password
    subnetId: nestedDependencies.outputs.subnetResourceId
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    databases: [
      {
        backupLongTermRetentionPolicies: {
          name: 'default'
        }
        backupShortTermRetentionPolicies: {
          name: 'default'
        }
        name: '${namePrefix}-${serviceShort}-db-001'
      }
    ]
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    dnsZonePartner: ''
    encryptionProtectorObj: {
      serverKeyName: '${nestedDependencies.outputs.keyVaultName}_${nestedDependencies.outputs.keyVaultKeyName}_${last(split(nestedDependencies.outputs.keyVaultEncryptionKeyUrl, '/'))}'
      serverKeyType: 'AzureKeyVault'
    }
    hardwareFamily: 'Gen5'
    keys: [
      {
        name: '${nestedDependencies.outputs.keyVaultName}_${nestedDependencies.outputs.keyVaultKeyName}_${last(split(nestedDependencies.outputs.keyVaultEncryptionKeyUrl, '/'))}'
        serverKeyType: 'AzureKeyVault'
        uri: nestedDependencies.outputs.keyVaultEncryptionKeyUrl
      }
    ]
    licenseType: 'LicenseIncluded'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    primaryUserAssignedIdentityId: nestedDependencies.outputs.managedIdentityResourceId
    proxyOverride: 'Proxy'
    publicDataEndpointEnabled: false
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    securityAlertPoliciesObj: {
      emailAccountAdmins: true
      name: 'default'
      state: 'Enabled'
    }
    servicePrincipal: 'SystemAssigned'
    skuName: 'GP_Gen5'
    skuTier: 'GeneralPurpose'
    storageSizeInGB: 32
    systemAssignedIdentity: true
    timezoneId: 'UTC'
    userAssignedIdentities: {
      '${nestedDependencies.outputs.managedIdentityResourceId}': {}
    }
    vCores: 4
    vulnerabilityAssessmentsObj: {
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
      storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
}
