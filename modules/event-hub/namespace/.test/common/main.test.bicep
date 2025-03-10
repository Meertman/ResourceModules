targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-eventhub.namespaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ehncom'

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
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/.templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
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
    name: '${namePrefix}${serviceShort}001'
    zoneRedundant: true
    skuName: 'Standard'
    skuCapacity: 2
    authorizationRules: [
      {
        name: 'RootManageSharedAccessKey'
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
      {
        name: 'SendListenAccess'
        rights: [
          'Listen'
          'Send'
        ]
      }
    ]
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    eventhubs: [
      {
        name: '${namePrefix}-az-evh-x-001'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
      }
      {
        name: '${namePrefix}-az-evh-x-002'
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
          {
            name: 'SendListenAccess'
            rights: [
              'Listen'
              'Send'
            ]
          }
        ]
        captureDescriptionDestinationArchiveNameFormat: '{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'
        captureDescriptionDestinationBlobContainer: 'eventhub'
        captureDescriptionDestinationName: 'EventHubArchive.AzureBlockBlob'
        captureDescriptionDestinationStorageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
        captureDescriptionEnabled: true
        captureDescriptionEncoding: 'Avro'
        captureDescriptionIntervalInSeconds: 300
        captureDescriptionSizeLimitInBytes: 314572800
        captureDescriptionSkipEmptyArchives: true
        consumergroups: [
          {
            name: 'custom'
            userMetadata: 'customMetadata'
          }
        ]
        messageRetentionInDays: 1
        partitionCount: 2
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        status: 'Active'
        retentionDescriptionCleanupPolicy: 'Delete'
        retentionDescriptionRetentionTimeInHours: 3
      }
      {
        name: '${namePrefix}-az-evh-x-003'
        retentionDescriptionCleanupPolicy: 'Compact'
        retentionDescriptionTombstoneRetentionTimeInHours: 24
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    networkRuleSets: {
      defaultAction: 'Deny'
      ipRules: [
        {
          action: 'Allow'
          ipMask: '10.10.10.10'
        }
      ]
      trustedServiceAccessEnabled: false
      virtualNetworkRules: [
        {
          ignoreMissingVnetServiceEndpoint: true
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
        }
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
        service: 'namespace'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '${nestedDependencies.outputs.managedIdentityResourceId}': {}
    }
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    kafkaEnabled: true
    disableLocalAuth: true
    isAutoInflateEnabled: true
    minimumTlsVersion: '1.2'
    maximumThroughputUnits: 4
    publicNetworkAccess: 'Disabled'
  }
}
