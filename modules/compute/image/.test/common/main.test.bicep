targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.images-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cicom'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    diskEncryptionSetName: 'dep-${namePrefix}-des-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}01'
    imageTemplateNamePrefix: 'dep-${namePrefix}-imgt-${serviceShort}'
    triggerImageDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}-triggerImageTemplate'
    copyVhdDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}-copyVhdToStorage'
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
    osAccountType: 'Premium_LRS'
    osDiskBlobUri: nestedDependencies.outputs.vhdUri
    osDiskCaching: 'ReadWrite'
    osType: 'Windows'
    hyperVGeneration: 'V1'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    zoneResilient: true
    diskEncryptionSetResourceId: nestedDependencies.outputs.diskEncryptionSetResourceId
    osState: 'Generalized'
    diskSizeGB: 128
    tags: {
      'hidden-title': 'This is visible in the resource name'
      tagA: 'You\'re it'
      tagB: 'Player'
    }
  }
}
