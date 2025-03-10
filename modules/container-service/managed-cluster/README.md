# Azure Kubernetes Service (AKS) Managed Clusters `[Microsoft.ContainerService/managedClusters]`

This module deploys an Azure Kubernetes Service (AKS) Managed Cluster.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ContainerService/managedClusters` | [2023-07-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2023-07-02-preview/managedClusters) |
| `Microsoft.ContainerService/managedClusters/agentPools` | [2023-07-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2023-07-02-preview/managedClusters/agentPools) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KubernetesConfiguration/extensions` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/extensions) |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/fluxConfigurations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/container-service.managed-cluster:1.0.0`.

- [Azure](#example-1-azure)
- [Kubenet](#example-2-kubenet)
- [Using only defaults](#example-3-using-only-defaults)
- [Priv](#example-4-priv)

### Example 1: _Azure_

<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br:bicep/modules/container-service.managed-cluster:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-csmaz'
  params: {
    // Required parameters
    name: 'csmaz001'
    primaryAgentPoolProfile: [
      {
        availabilityZones: [
          '3'
        ]
        count: 1
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        mode: 'System'
        name: 'systempool'
        osDiskSizeGB: 0
        osType: 'Linux'
        serviceCidr: ''
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
    ]
    // Non-required parameters
    agentPools: [
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        proximityPlacementGroupResourceId: '<proximityPlacementGroupResourceId>'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool2'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
    ]
    autoUpgradeProfileUpgradeChannel: 'stable'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    diskEncryptionSetID: '<diskEncryptionSetID>'
    enableAzureDefender: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableKeyvaultSecretsProvider: true
    enableOidcIssuerProfile: true
    enablePodSecurityPolicy: false
    enableStorageProfileBlobCSIDriver: true
    enableStorageProfileDiskCSIDriver: true
    enableStorageProfileFileCSIDriver: true
    enableStorageProfileSnapshotController: true
    enableWorkloadIdentity: true
    fluxExtension: {
      configurations: [
        {
          gitRepository: {
            repositoryRef: {
              branch: 'main'
            }
            sshKnownHosts: ''
            syncIntervalInSeconds: 300
            timeoutInSeconds: 180
            url: 'https://github.com/mspnp/aks-baseline'
          }
          namespace: 'flux-system'
        }
        {
          gitRepository: {
            repositoryRef: {
              branch: 'main'
            }
            sshKnownHosts: ''
            syncIntervalInSeconds: 300
            timeoutInSeconds: 180
            url: 'https://github.com/Azure/gitops-flux2-kustomize-helm-mt'
          }
          kustomizations: {
            apps: {
              dependsOn: [
                'infra'
              ]
              path: './apps/staging'
              prune: true
              retryIntervalInSeconds: 120
              syncIntervalInSeconds: 600
              timeoutInSeconds: 600
            }
            infra: {
              dependsOn: []
              path: './infrastructure'
              prune: true
              syncIntervalInSeconds: 600
              timeoutInSeconds: 600
              validation: 'none'
            }
          }
          namespace: 'flux-system-helm'
        }
      ]
      configurationSettings: {
        'helm-controller.enabled': 'true'
        'image-automation-controller.enabled': 'false'
        'image-reflector-controller.enabled': 'false'
        'kustomize-controller.enabled': 'true'
        'notification-controller.enabled': 'true'
        'source-controller.enabled': 'true'
      }
    }
    identityProfile: {
      kubeletidentity: {
        resourceId: '<resourceId>'
      }
    }
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    monitoringWorkspaceId: '<monitoringWorkspaceId>'
    networkDataplane: 'azure'
    networkPlugin: 'azure'
    networkPluginMode: 'overlay'
    omsAgentEnabled: true
    openServiceMeshEnabled: true
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "csmaz001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 1,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "mode": "System",
          "name": "systempool",
          "osDiskSizeGB": 0,
          "osType": "Linux",
          "serviceCidr": "",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        }
      ]
    },
    // Non-required parameters
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool1",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "proximityPlacementGroupResourceId": "<proximityPlacementGroupResourceId>",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        },
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool2",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        }
      ]
    },
    "autoUpgradeProfileUpgradeChannel": {
      "value": "stable"
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "diskEncryptionSetID": {
      "value": "<diskEncryptionSetID>"
    },
    "enableAzureDefender": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enableKeyvaultSecretsProvider": {
      "value": true
    },
    "enableOidcIssuerProfile": {
      "value": true
    },
    "enablePodSecurityPolicy": {
      "value": false
    },
    "enableStorageProfileBlobCSIDriver": {
      "value": true
    },
    "enableStorageProfileDiskCSIDriver": {
      "value": true
    },
    "enableStorageProfileFileCSIDriver": {
      "value": true
    },
    "enableStorageProfileSnapshotController": {
      "value": true
    },
    "enableWorkloadIdentity": {
      "value": true
    },
    "fluxExtension": {
      "value": {
        "configurations": [
          {
            "gitRepository": {
              "repositoryRef": {
                "branch": "main"
              },
              "sshKnownHosts": "",
              "syncIntervalInSeconds": 300,
              "timeoutInSeconds": 180,
              "url": "https://github.com/mspnp/aks-baseline"
            },
            "namespace": "flux-system"
          },
          {
            "gitRepository": {
              "repositoryRef": {
                "branch": "main"
              },
              "sshKnownHosts": "",
              "syncIntervalInSeconds": 300,
              "timeoutInSeconds": 180,
              "url": "https://github.com/Azure/gitops-flux2-kustomize-helm-mt"
            },
            "kustomizations": {
              "apps": {
                "dependsOn": [
                  "infra"
                ],
                "path": "./apps/staging",
                "prune": true,
                "retryIntervalInSeconds": 120,
                "syncIntervalInSeconds": 600,
                "timeoutInSeconds": 600
              },
              "infra": {
                "dependsOn": [],
                "path": "./infrastructure",
                "prune": true,
                "syncIntervalInSeconds": 600,
                "timeoutInSeconds": 600,
                "validation": "none"
              }
            },
            "namespace": "flux-system-helm"
          }
        ],
        "configurationSettings": {
          "helm-controller.enabled": "true",
          "image-automation-controller.enabled": "false",
          "image-reflector-controller.enabled": "false",
          "kustomize-controller.enabled": "true",
          "notification-controller.enabled": "true",
          "source-controller.enabled": "true"
        }
      }
    },
    "identityProfile": {
      "value": {
        "kubeletidentity": {
          "resourceId": "<resourceId>"
        }
      }
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "monitoringWorkspaceId": {
      "value": "<monitoringWorkspaceId>"
    },
    "networkDataplane": {
      "value": "azure"
    },
    "networkPlugin": {
      "value": "azure"
    },
    "networkPluginMode": {
      "value": "overlay"
    },
    "omsAgentEnabled": {
      "value": true
    },
    "openServiceMeshEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Kubenet_

<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br:bicep/modules/container-service.managed-cluster:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-csmkube'
  params: {
    // Required parameters
    name: 'csmkube001'
    primaryAgentPoolProfile: [
      {
        availabilityZones: [
          '3'
        ]
        count: 1
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        mode: 'System'
        name: 'systempool'
        osDiskSizeGB: 0
        osType: 'Linux'
        serviceCidr: ''
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    // Non-required parameters
    agentPools: [
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool2'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    networkPlugin: 'kubenet'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "csmkube001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 1,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "mode": "System",
          "name": "systempool",
          "osDiskSizeGB": 0,
          "osType": "Linux",
          "serviceCidr": "",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    // Non-required parameters
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool1",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        },
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool2",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "networkPlugin": {
      "value": "kubenet"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

### Example 3: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br:bicep/modules/container-service.managed-cluster:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-csmmin'
  params: {
    // Required parameters
    name: 'csmmin001'
    primaryAgentPoolProfile: [
      {
        count: 1
        mode: 'System'
        name: 'systempool'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    systemAssignedIdentity: true
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "csmmin001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "count": 1,
          "mode": "System",
          "name": "systempool",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "systemAssignedIdentity": {
      "value": true
    }
  }
}
```

</details>
<p>

### Example 4: _Priv_

<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br:bicep/modules/container-service.managed-cluster:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-csmpriv'
  params: {
    // Required parameters
    name: 'csmpriv001'
    primaryAgentPoolProfile: [
      {
        availabilityZones: [
          '3'
        ]
        count: 1
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        mode: 'System'
        name: 'systempool'
        osDiskSizeGB: 0
        osType: 'Linux'
        serviceCidr: ''
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
    ]
    // Non-required parameters
    agentPools: [
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool2'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    dnsServiceIP: '10.10.200.10'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enablePrivateCluster: true
    networkPlugin: 'azure'
    privateDNSZone: '<privateDNSZone>'
    serviceCidr: '10.10.200.0/24'
    skuTier: 'Standard'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "csmpriv001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 1,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "mode": "System",
          "name": "systempool",
          "osDiskSizeGB": 0,
          "osType": "Linux",
          "serviceCidr": "",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        }
      ]
    },
    // Non-required parameters
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool1",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        },
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool2",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "dnsServiceIP": {
      "value": "10.10.200.10"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enablePrivateCluster": {
      "value": true
    },
    "networkPlugin": {
      "value": "azure"
    },
    "privateDNSZone": {
      "value": "<privateDNSZone>"
    },
    "serviceCidr": {
      "value": "10.10.200.0/24"
    },
    "skuTier": {
      "value": "Standard"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Specifies the name of the AKS cluster. |
| [`primaryAgentPoolProfile`](#parameter-primaryagentpoolprofile) | array | Properties of the primary agent pool. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aksServicePrincipalProfile`](#parameter-aksserviceprincipalprofile) | object | Information about a service principal identity for the cluster to use for manipulating Azure APIs. Required if no managed identities are assigned to the cluster. |
| [`appGatewayResourceId`](#parameter-appgatewayresourceid) | string | Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadProfileAdminGroupObjectIDs`](#parameter-aadprofileadmingroupobjectids) | array | Specifies the AAD group object IDs that will have admin role of the cluster. |
| [`aadProfileClientAppID`](#parameter-aadprofileclientappid) | string | The client AAD application ID. |
| [`aadProfileEnableAzureRBAC`](#parameter-aadprofileenableazurerbac) | bool | Specifies whether to enable Azure RBAC for Kubernetes authorization. |
| [`aadProfileManaged`](#parameter-aadprofilemanaged) | bool | Specifies whether to enable managed AAD integration. |
| [`aadProfileServerAppID`](#parameter-aadprofileserverappid) | string | The server AAD application ID. |
| [`aadProfileServerAppSecret`](#parameter-aadprofileserverappsecret) | string | The server AAD application secret. |
| [`aadProfileTenantId`](#parameter-aadprofiletenantid) | string | Specifies the tenant ID of the Azure Active Directory used by the AKS cluster for authentication. |
| [`aciConnectorLinuxEnabled`](#parameter-aciconnectorlinuxenabled) | bool | Specifies whether the aciConnectorLinux add-on is enabled or not. |
| [`adminUsername`](#parameter-adminusername) | string | Specifies the administrator username of Linux virtual machines. |
| [`agentPools`](#parameter-agentpools) | array | Define one or more secondary/additional agent pools. |
| [`authorizedIPRanges`](#parameter-authorizedipranges) | array | IP ranges are specified in CIDR format, e.g. 137.117.106.88/29. This feature is not compatible with clusters that use Public IP Per Node, or clusters that are using a Basic Load Balancer. |
| [`autoScalerProfileBalanceSimilarNodeGroups`](#parameter-autoscalerprofilebalancesimilarnodegroups) | string | Specifies the balance of similar node groups for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileExpander`](#parameter-autoscalerprofileexpander) | string | Specifies the expand strategy for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileMaxEmptyBulkDelete`](#parameter-autoscalerprofilemaxemptybulkdelete) | string | Specifies the maximum empty bulk delete for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileMaxGracefulTerminationSec`](#parameter-autoscalerprofilemaxgracefulterminationsec) | string | Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileMaxNodeProvisionTime`](#parameter-autoscalerprofilemaxnodeprovisiontime) | string | Specifies the maximum node provisioning time for the auto-scaler of the AKS cluster. Values must be an integer followed by an "m". No unit of time other than minutes (m) is supported. |
| [`autoScalerProfileMaxTotalUnreadyPercentage`](#parameter-autoscalerprofilemaxtotalunreadypercentage) | string | Specifies the mximum total unready percentage for the auto-scaler of the AKS cluster. The maximum is 100 and the minimum is 0. |
| [`autoScalerProfileNewPodScaleUpDelay`](#parameter-autoscalerprofilenewpodscaleupdelay) | string | For scenarios like burst/batch scale where you do not want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they are a certain age. Values must be an integer followed by a unit ("s" for seconds, "m" for minutes, "h" for hours, etc). |
| [`autoScalerProfileOkTotalUnreadyCount`](#parameter-autoscalerprofileoktotalunreadycount) | string | Specifies the OK total unready count for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScaleDownDelayAfterAdd`](#parameter-autoscalerprofilescaledowndelayafteradd) | string | Specifies the scale down delay after add of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScaleDownDelayAfterDelete`](#parameter-autoscalerprofilescaledowndelayafterdelete) | string | Specifies the scale down delay after delete of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScaleDownDelayAfterFailure`](#parameter-autoscalerprofilescaledowndelayafterfailure) | string | Specifies scale down delay after failure of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScaleDownUnneededTime`](#parameter-autoscalerprofilescaledownunneededtime) | string | Specifies the scale down unneeded time of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScaleDownUnreadyTime`](#parameter-autoscalerprofilescaledownunreadytime) | string | Specifies the scale down unready time of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScanInterval`](#parameter-autoscalerprofilescaninterval) | string | Specifies the scan interval of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileSkipNodesWithLocalStorage`](#parameter-autoscalerprofileskipnodeswithlocalstorage) | string | Specifies if nodes with local storage should be skipped for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileSkipNodesWithSystemPods`](#parameter-autoscalerprofileskipnodeswithsystempods) | string | Specifies if nodes with system pods should be skipped for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileUtilizationThreshold`](#parameter-autoscalerprofileutilizationthreshold) | string | Specifies the utilization threshold of the auto-scaler of the AKS cluster. |
| [`autoUpgradeProfileUpgradeChannel`](#parameter-autoupgradeprofileupgradechannel) | string | Auto-upgrade channel on the AKS cluster. |
| [`azurePolicyEnabled`](#parameter-azurepolicyenabled) | bool | Specifies whether the azurepolicy add-on is enabled or not. For security reasons, this setting should be enabled. |
| [`azurePolicyVersion`](#parameter-azurepolicyversion) | string | Specifies the azure policy version to use. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`disableLocalAccounts`](#parameter-disablelocalaccounts) | bool | If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled. |
| [`disableRunCommand`](#parameter-disableruncommand) | bool | Whether to disable run command for the cluster or not. |
| [`diskEncryptionSetID`](#parameter-diskencryptionsetid) | string | The resource ID of the disc encryption set to apply to the cluster. For security reasons, this value should be provided. |
| [`dnsPrefix`](#parameter-dnsprefix) | string | Specifies the DNS prefix specified when creating the managed cluster. |
| [`dnsServiceIP`](#parameter-dnsserviceip) | string | Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr. |
| [`dnsZoneResourceId`](#parameter-dnszoneresourceid) | string | Specifies the resource ID of connected DNS zone. It will be ignored if `webApplicationRoutingEnabled` is set to `false`. |
| [`enableAzureDefender`](#parameter-enableazuredefender) | bool | Whether to enable Azure Defender. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enableDnsZoneContributorRoleAssignment`](#parameter-enablednszonecontributorroleassignment) | bool | Specifies whether assing the DNS zone contributor role to the cluster service principal. It will be ignored if `webApplicationRoutingEnabled` is set to `false` or `dnsZoneResourceId` not provided. |
| [`enableKeyvaultSecretsProvider`](#parameter-enablekeyvaultsecretsprovider) | bool | Specifies whether the KeyvaultSecretsProvider add-on is enabled or not. |
| [`enableOidcIssuerProfile`](#parameter-enableoidcissuerprofile) | bool | Whether the The OIDC issuer profile of the Managed Cluster is enabled. |
| [`enablePodSecurityPolicy`](#parameter-enablepodsecuritypolicy) | bool | Whether to enable Kubernetes pod security policy. Requires enabling the pod security policy feature flag on the subscription. |
| [`enablePrivateCluster`](#parameter-enableprivatecluster) | bool | Specifies whether to create the cluster as a private cluster or not. |
| [`enablePrivateClusterPublicFQDN`](#parameter-enableprivateclusterpublicfqdn) | bool | Whether to create additional public FQDN for private cluster or not. |
| [`enableRBAC`](#parameter-enablerbac) | bool | Whether to enable Kubernetes Role-Based Access Control. |
| [`enableSecretRotation`](#parameter-enablesecretrotation) | string | Specifies whether the KeyvaultSecretsProvider add-on uses secret rotation. |
| [`enableStorageProfileBlobCSIDriver`](#parameter-enablestorageprofileblobcsidriver) | bool | Whether the AzureBlob CSI Driver for the storage profile is enabled. |
| [`enableStorageProfileDiskCSIDriver`](#parameter-enablestorageprofilediskcsidriver) | bool | Whether the AzureDisk CSI Driver for the storage profile is enabled. |
| [`enableStorageProfileFileCSIDriver`](#parameter-enablestorageprofilefilecsidriver) | bool | Whether the AzureFile CSI Driver for the storage profile is enabled. |
| [`enableStorageProfileSnapshotController`](#parameter-enablestorageprofilesnapshotcontroller) | bool | Whether the snapshot controller for the storage profile is enabled. |
| [`enableWorkloadIdentity`](#parameter-enableworkloadidentity) | bool | Whether to enable Workload Identity. Requires OIDC issuer profile to be enabled. |
| [`fluxConfigurationProtectedSettings`](#parameter-fluxconfigurationprotectedsettings) | secureObject | Configuration settings that are sensitive, as name-value pairs for configuring this extension. |
| [`fluxExtension`](#parameter-fluxextension) | object | Settings and configurations for the flux extension. |
| [`httpApplicationRoutingEnabled`](#parameter-httpapplicationroutingenabled) | bool | Specifies whether the httpApplicationRouting add-on is enabled or not. |
| [`httpProxyConfig`](#parameter-httpproxyconfig) | object | Configurations for provisioning the cluster with HTTP proxy servers. |
| [`identityProfile`](#parameter-identityprofile) | object | Identities associated with the cluster. |
| [`ingressApplicationGatewayEnabled`](#parameter-ingressapplicationgatewayenabled) | bool | Specifies whether the ingressApplicationGateway (AGIC) add-on is enabled or not. |
| [`kubeDashboardEnabled`](#parameter-kubedashboardenabled) | bool | Specifies whether the kubeDashboard add-on is enabled or not. |
| [`kubernetesVersion`](#parameter-kubernetesversion) | string | Version of Kubernetes specified when creating the managed cluster. |
| [`loadBalancerSku`](#parameter-loadbalancersku) | string | Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools. |
| [`location`](#parameter-location) | string | Specifies the location of AKS cluster. It picks up Resource Group's location by default. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedOutboundIPCount`](#parameter-managedoutboundipcount) | int | Outbound IP Count for the Load balancer. |
| [`monitoringWorkspaceId`](#parameter-monitoringworkspaceid) | string | Resource ID of the monitoring log analytics workspace. |
| [`networkDataplane`](#parameter-networkdataplane) | string | Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin. |
| [`networkPlugin`](#parameter-networkplugin) | string | Specifies the network plugin used for building Kubernetes network. |
| [`networkPluginMode`](#parameter-networkpluginmode) | string | Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin. |
| [`networkPolicy`](#parameter-networkpolicy) | string | Specifies the network policy used for building Kubernetes network. - calico or azure. |
| [`nodeResourceGroup`](#parameter-noderesourcegroup) | string | Name of the resource group containing agent pool nodes. |
| [`omsAgentEnabled`](#parameter-omsagentenabled) | bool | Specifies whether the OMS agent is enabled. |
| [`openServiceMeshEnabled`](#parameter-openservicemeshenabled) | bool | Specifies whether the openServiceMesh add-on is enabled or not. |
| [`outboundType`](#parameter-outboundtype) | string | Specifies outbound (egress) routing method. - loadBalancer or userDefinedRouting. |
| [`podCidr`](#parameter-podcidr) | string | Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used. |
| [`podIdentityProfileAllowNetworkPluginKubenet`](#parameter-podidentityprofileallownetworkpluginkubenet) | bool | Running in Kubenet is disabled by default due to the security related nature of AAD Pod Identity and the risks of IP spoofing. |
| [`podIdentityProfileEnable`](#parameter-podidentityprofileenable) | bool | Whether the pod identity addon is enabled. |
| [`podIdentityProfileUserAssignedIdentities`](#parameter-podidentityprofileuserassignedidentities) | array | The pod identities to use in the cluster. |
| [`podIdentityProfileUserAssignedIdentityExceptions`](#parameter-podidentityprofileuserassignedidentityexceptions) | array | The pod identity exceptions to allow. |
| [`privateDNSZone`](#parameter-privatednszone) | string | Private DNS Zone configuration. Set to 'system' and AKS will create a private DNS zone in the node resource group. Set to '' to disable private DNS Zone creation and use public DNS. Supply the resource ID here of an existing Private DNS zone to use an existing zone. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`serviceCidr`](#parameter-servicecidr) | string | A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges. |
| [`skuTier`](#parameter-skutier) | string | Tier of a managed cluster SKU. - Free or Standard. |
| [`sshPublicKey`](#parameter-sshpublickey) | string | Specifies the SSH RSA public key string for the Linux nodes. |
| [`supportPlan`](#parameter-supportplan) | string | The support plan for the Managed Cluster. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |
| [`webApplicationRoutingEnabled`](#parameter-webapplicationroutingenabled) | bool | Specifies whether the webApplicationRoutingEnabled add-on is enabled or not. |

### Parameter: `aadProfileAdminGroupObjectIDs`

Specifies the AAD group object IDs that will have admin role of the cluster.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `aadProfileClientAppID`

The client AAD application ID.
- Required: No
- Type: string
- Default: `''`

### Parameter: `aadProfileEnableAzureRBAC`

Specifies whether to enable Azure RBAC for Kubernetes authorization.
- Required: No
- Type: bool
- Default: `[parameters('enableRBAC')]`

### Parameter: `aadProfileManaged`

Specifies whether to enable managed AAD integration.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `aadProfileServerAppID`

The server AAD application ID.
- Required: No
- Type: string
- Default: `''`

### Parameter: `aadProfileServerAppSecret`

The server AAD application secret.
- Required: No
- Type: string
- Default: `''`

### Parameter: `aadProfileTenantId`

Specifies the tenant ID of the Azure Active Directory used by the AKS cluster for authentication.
- Required: No
- Type: string
- Default: `[subscription().tenantId]`

### Parameter: `aciConnectorLinuxEnabled`

Specifies whether the aciConnectorLinux add-on is enabled or not.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `adminUsername`

Specifies the administrator username of Linux virtual machines.
- Required: No
- Type: string
- Default: `'azureuser'`

### Parameter: `agentPools`

Define one or more secondary/additional agent pools.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `aksServicePrincipalProfile`

Information about a service principal identity for the cluster to use for manipulating Azure APIs. Required if no managed identities are assigned to the cluster.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `appGatewayResourceId`

Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`.
- Required: No
- Type: string
- Default: `''`

### Parameter: `authorizedIPRanges`

IP ranges are specified in CIDR format, e.g. 137.117.106.88/29. This feature is not compatible with clusters that use Public IP Per Node, or clusters that are using a Basic Load Balancer.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `autoScalerProfileBalanceSimilarNodeGroups`

Specifies the balance of similar node groups for the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'false'`
- Allowed: `[false, true]`

### Parameter: `autoScalerProfileExpander`

Specifies the expand strategy for the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'random'`
- Allowed: `[least-waste, most-pods, priority, random]`

### Parameter: `autoScalerProfileMaxEmptyBulkDelete`

Specifies the maximum empty bulk delete for the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'10'`

### Parameter: `autoScalerProfileMaxGracefulTerminationSec`

Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'600'`

### Parameter: `autoScalerProfileMaxNodeProvisionTime`

Specifies the maximum node provisioning time for the auto-scaler of the AKS cluster. Values must be an integer followed by an "m". No unit of time other than minutes (m) is supported.
- Required: No
- Type: string
- Default: `'15m'`

### Parameter: `autoScalerProfileMaxTotalUnreadyPercentage`

Specifies the mximum total unready percentage for the auto-scaler of the AKS cluster. The maximum is 100 and the minimum is 0.
- Required: No
- Type: string
- Default: `'45'`

### Parameter: `autoScalerProfileNewPodScaleUpDelay`

For scenarios like burst/batch scale where you do not want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they are a certain age. Values must be an integer followed by a unit ("s" for seconds, "m" for minutes, "h" for hours, etc).
- Required: No
- Type: string
- Default: `'0s'`

### Parameter: `autoScalerProfileOkTotalUnreadyCount`

Specifies the OK total unready count for the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'3'`

### Parameter: `autoScalerProfileScaleDownDelayAfterAdd`

Specifies the scale down delay after add of the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'10m'`

### Parameter: `autoScalerProfileScaleDownDelayAfterDelete`

Specifies the scale down delay after delete of the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'20s'`

### Parameter: `autoScalerProfileScaleDownDelayAfterFailure`

Specifies scale down delay after failure of the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'3m'`

### Parameter: `autoScalerProfileScaleDownUnneededTime`

Specifies the scale down unneeded time of the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'10m'`

### Parameter: `autoScalerProfileScaleDownUnreadyTime`

Specifies the scale down unready time of the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'20m'`

### Parameter: `autoScalerProfileScanInterval`

Specifies the scan interval of the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'10s'`

### Parameter: `autoScalerProfileSkipNodesWithLocalStorage`

Specifies if nodes with local storage should be skipped for the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'true'`
- Allowed: `[false, true]`

### Parameter: `autoScalerProfileSkipNodesWithSystemPods`

Specifies if nodes with system pods should be skipped for the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'true'`
- Allowed: `[false, true]`

### Parameter: `autoScalerProfileUtilizationThreshold`

Specifies the utilization threshold of the auto-scaler of the AKS cluster.
- Required: No
- Type: string
- Default: `'0.5'`

### Parameter: `autoUpgradeProfileUpgradeChannel`

Auto-upgrade channel on the AKS cluster.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', node-image, none, patch, rapid, stable]`

### Parameter: `azurePolicyEnabled`

Specifies whether the azurepolicy add-on is enabled or not. For security reasons, this setting should be enabled.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `azurePolicyVersion`

Specifies the azure policy version to use.
- Required: No
- Type: string
- Default: `'v2'`

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticLogCategoriesToEnable`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array
- Default: `[allLogs]`
- Allowed: `['', allLogs, cluster-autoscaler, guard, kube-apiserver, kube-audit, kube-audit-admin, kube-controller-manager, kube-scheduler]`

### Parameter: `diagnosticMetricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[AllMetrics]`
- Allowed: `[AllMetrics]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `disableLocalAccounts`

If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `disableRunCommand`

Whether to disable run command for the cluster or not.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `diskEncryptionSetID`

The resource ID of the disc encryption set to apply to the cluster. For security reasons, this value should be provided.
- Required: No
- Type: string
- Default: `''`

### Parameter: `dnsPrefix`

Specifies the DNS prefix specified when creating the managed cluster.
- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `dnsServiceIP`

Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.
- Required: No
- Type: string
- Default: `''`

### Parameter: `dnsZoneResourceId`

Specifies the resource ID of connected DNS zone. It will be ignored if `webApplicationRoutingEnabled` is set to `false`.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableAzureDefender`

Whether to enable Azure Defender.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableDnsZoneContributorRoleAssignment`

Specifies whether assing the DNS zone contributor role to the cluster service principal. It will be ignored if `webApplicationRoutingEnabled` is set to `false` or `dnsZoneResourceId` not provided.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableKeyvaultSecretsProvider`

Specifies whether the KeyvaultSecretsProvider add-on is enabled or not.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableOidcIssuerProfile`

Whether the The OIDC issuer profile of the Managed Cluster is enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePodSecurityPolicy`

Whether to enable Kubernetes pod security policy. Requires enabling the pod security policy feature flag on the subscription.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePrivateCluster`

Specifies whether to create the cluster as a private cluster or not.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePrivateClusterPublicFQDN`

Whether to create additional public FQDN for private cluster or not.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRBAC`

Whether to enable Kubernetes Role-Based Access Control.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableSecretRotation`

Specifies whether the KeyvaultSecretsProvider add-on uses secret rotation.
- Required: No
- Type: string
- Default: `'false'`
- Allowed: `[false, true]`

### Parameter: `enableStorageProfileBlobCSIDriver`

Whether the AzureBlob CSI Driver for the storage profile is enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableStorageProfileDiskCSIDriver`

Whether the AzureDisk CSI Driver for the storage profile is enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableStorageProfileFileCSIDriver`

Whether the AzureFile CSI Driver for the storage profile is enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableStorageProfileSnapshotController`

Whether the snapshot controller for the storage profile is enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableWorkloadIdentity`

Whether to enable Workload Identity. Requires OIDC issuer profile to be enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `fluxConfigurationProtectedSettings`

Configuration settings that are sensitive, as name-value pairs for configuring this extension.
- Required: No
- Type: secureObject
- Default: `{object}`

### Parameter: `fluxExtension`

Settings and configurations for the flux extension.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `httpApplicationRoutingEnabled`

Specifies whether the httpApplicationRouting add-on is enabled or not.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `httpProxyConfig`

Configurations for provisioning the cluster with HTTP proxy servers.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `identityProfile`

Identities associated with the cluster.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `ingressApplicationGatewayEnabled`

Specifies whether the ingressApplicationGateway (AGIC) add-on is enabled or not.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `kubeDashboardEnabled`

Specifies whether the kubeDashboard add-on is enabled or not.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `kubernetesVersion`

Version of Kubernetes specified when creating the managed cluster.
- Required: No
- Type: string
- Default: `''`

### Parameter: `loadBalancerSku`

Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools.
- Required: No
- Type: string
- Default: `'standard'`
- Allowed: `[basic, standard]`

### Parameter: `location`

Specifies the location of AKS cluster. It picks up Resource Group's location by default.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `managedOutboundIPCount`

Outbound IP Count for the Load balancer.
- Required: No
- Type: int
- Default: `0`

### Parameter: `monitoringWorkspaceId`

Resource ID of the monitoring log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `name`

Specifies the name of the AKS cluster.
- Required: Yes
- Type: string

### Parameter: `networkDataplane`

Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', azure, cilium]`

### Parameter: `networkPlugin`

Specifies the network plugin used for building Kubernetes network.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', azure, kubenet]`

### Parameter: `networkPluginMode`

Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', overlay]`

### Parameter: `networkPolicy`

Specifies the network policy used for building Kubernetes network. - calico or azure.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', azure, calico]`

### Parameter: `nodeResourceGroup`

Name of the resource group containing agent pool nodes.
- Required: No
- Type: string
- Default: `[format('{0}_aks_{1}_nodes', resourceGroup().name, parameters('name'))]`

### Parameter: `omsAgentEnabled`

Specifies whether the OMS agent is enabled.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `openServiceMeshEnabled`

Specifies whether the openServiceMesh add-on is enabled or not.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `outboundType`

Specifies outbound (egress) routing method. - loadBalancer or userDefinedRouting.
- Required: No
- Type: string
- Default: `'loadBalancer'`
- Allowed: `[loadBalancer, userDefinedRouting]`

### Parameter: `podCidr`

Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used.
- Required: No
- Type: string
- Default: `''`

### Parameter: `podIdentityProfileAllowNetworkPluginKubenet`

Running in Kubenet is disabled by default due to the security related nature of AAD Pod Identity and the risks of IP spoofing.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `podIdentityProfileEnable`

Whether the pod identity addon is enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `podIdentityProfileUserAssignedIdentities`

The pod identities to use in the cluster.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `podIdentityProfileUserAssignedIdentityExceptions`

The pod identity exceptions to allow.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `primaryAgentPoolProfile`

Properties of the primary agent pool.
- Required: Yes
- Type: array

### Parameter: `privateDNSZone`

Private DNS Zone configuration. Set to 'system' and AKS will create a private DNS zone in the node resource group. Set to '' to disable private DNS Zone creation and use public DNS. Supply the resource ID here of an existing Private DNS zone to use an existing zone.
- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `serviceCidr`

A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.
- Required: No
- Type: string
- Default: `''`

### Parameter: `skuTier`

Tier of a managed cluster SKU. - Free or Standard.
- Required: No
- Type: string
- Default: `'Free'`
- Allowed: `[Free, Premium, Standard]`

### Parameter: `sshPublicKey`

Specifies the SSH RSA public key string for the Linux nodes.
- Required: No
- Type: string
- Default: `''`

### Parameter: `supportPlan`

The support plan for the Managed Cluster.
- Required: No
- Type: string
- Default: `'KubernetesOfficial'`
- Allowed: `[AKSLongTermSupport, KubernetesOfficial]`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `webApplicationRoutingEnabled`

Specifies whether the webApplicationRoutingEnabled add-on is enabled or not.
- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `addonProfiles` | object | The addonProfiles of the Kubernetes cluster. |
| `controlPlaneFQDN` | string | The control plane FQDN of the managed cluster. |
| `keyvaultIdentityClientId` | string | The Client ID of the Key Vault Secrets Provider identity. |
| `keyvaultIdentityObjectId` | string | The Object ID of the Key Vault Secrets Provider identity. |
| `kubeletidentityObjectId` | string | The Object ID of the AKS identity. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the managed cluster. |
| `oidcIssuerUrl` | string | The OIDC token issuer URL. |
| `omsagentIdentityObjectId` | string | The Object ID of the OMS agent identity. |
| `resourceGroupName` | string | The resource group the managed cluster was deployed into. |
| `resourceId` | string | The resource ID of the managed cluster. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/kubernetes-configuration/extension` | Local reference |
| `modules/kubernetes-configuration/flux-configuration` | Local reference |

## Notes

### Parameter Usage: `httpProxyConfig`

Configurations for provisioning the cluster with HTTP proxy servers. You can specify in the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"httpProxyConfig": {
    "value": {
        "httpProxy": "http://proxy.contoso.com:8080/",
        "httpsProxy": "http://proxy.contoso.com:8080/",
        "noProxy": [
            "10.0.0.0/8",
            "127.0.0.1",
            "168.63.129.16",
            "169.254.169.254",
            "azurecr.io",
            "konnectivity",
            "localhost"
        ]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
httpProxyConfig: {
  httpProxy: 'http://proxy.contoso.com:8080/'
  httpsProxy: 'http://proxy.contoso.com:8080/'
  noProxy: [
    '10.0.0.0/8'
    '127.0.0.1'
    '168.63.129.16'
    '169.254.169.254'
    'azurecr.io'
    'konnectivity'
    'localhost'
  ]
}
```

</details>
<p>
