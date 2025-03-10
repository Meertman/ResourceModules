targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.frontdoors-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nfdcom'

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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //
var resourceName = '${namePrefix}${serviceShort}001'
module testDeployment '../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: resourceName
    backendPools: [
      {
        name: 'backendPool'
        properties: {
          backends: [
            {
              address: 'biceptest.local'
              backendHostHeader: 'backendAddress'
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              privateLinkAlias: ''
              privateLinkApprovalMessage: ''
              privateLinkLocation: ''
              privateLinkResourceId: ''
              weight: 50
            }
          ]
          HealthProbeSettings: {
            id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/HealthProbeSettings/heathProbe'
          }
          LoadBalancingSettings: {
            id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/LoadBalancingSettings/loadBalancer'
          }
        }
      }
    ]
    enforceCertificateNameCheck: 'Disabled'
    frontendEndpoints: [
      {
        name: 'frontEnd'
        properties: {
          hostName: '${resourceName}.${environment().suffixes.azureFrontDoorEndpointSuffix}'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 60
        }
      }
    ]
    healthProbeSettings: [
      {
        name: 'heathProbe'
        properties: {
          enabledState: ''
          healthProbeMethod: ''
          intervalInSeconds: 60
          path: '/'
          protocol: 'Https'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'loadBalancer'
        properties: {
          additionalLatencyMilliseconds: 0
          sampleSize: 50
          successfulSamplesRequired: 1
        }
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    routingRules: [
      {
        name: 'routingRule'
        properties: {
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          enabledState: 'Enabled'
          frontendEndpoints: [
            {
              id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/FrontendEndpoints/frontEnd'
            }
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            backendPool: {
              id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/BackendPools/backendPool'
            }
            forwardingProtocol: 'MatchRequest'
          }
        }
      }
    ]
    sendRecvTimeoutSeconds: 10
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
  }
}
