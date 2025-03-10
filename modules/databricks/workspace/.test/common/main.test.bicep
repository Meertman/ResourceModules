targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-databricks.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dwcom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    amlWorkspaceName: 'dep-${namePrefix}-aml-${serviceShort}'
    applicationInsightsName: 'dep-${namePrefix}-appi-${serviceShort}'
    loadBalancerName: 'dep-${namePrefix}-lb-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    keyVaultDiskName: 'dep-${namePrefix}-kve-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/.templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}'
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
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    cMKManagedServicesKeyName: nestedDependencies.outputs.keyVaultKeyName
    cMKManagedServicesKeyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
    cMKManagedDisksKeyName: nestedDependencies.outputs.keyVaultDiskKeyName
    cMKManagedDisksKeyVaultResourceId: nestedDependencies.outputs.keyVaultDiskResourceId
    cMKManagedDisksKeyRotationToLatestKeyVersionEnabled: true
    storageAccountName: 'sa${namePrefix}${serviceShort}001'
    storageAccountSkuName: 'Standard_ZRS'
    publicIpName: 'nat-gw-public-ip'
    natGatewayName: 'nat-gateway'
    prepareEncryption: true
    requiredNsgRules: 'NoAzureDatabricksRules'
    skuName: 'premium'
    amlWorkspaceResourceId: nestedDependencies.outputs.machineLearningWorkspaceResourceId
    customPrivateSubnetName: nestedDependencies.outputs.customPrivateSubnetName
    customPublicSubnetName: nestedDependencies.outputs.customPublicSubnetName
    publicNetworkAccess: 'Disabled'
    disablePublicIp: true
    loadBalancerResourceId: nestedDependencies.outputs.loadBalancerResourceId
    loadBalancerBackendPoolName: nestedDependencies.outputs.loadBalancerBackendPoolName
    customVirtualNetworkResourceId: nestedDependencies.outputs.virtualNetworkResourceId
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
        subnetResourceId: nestedDependencies.outputs.defaultSubnetResourceId
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    managedResourceGroupResourceId: '${subscription().id}/resourceGroups/rg-${resourceGroupName}-managed'
    diagnosticLogCategoriesToEnable: [
      'jobs'
      'notebook'
    ]
    diagnosticSettingsName: 'diag${namePrefix}${serviceShort}001'
    requireInfrastructureEncryption: true
    vnetAddressPrefix: '10.100'
    location: resourceGroup.location
  }
}
