# Azure Compute Galleries `[Microsoft.Compute/galleries]`

This module deploys an Azure Compute Gallery (formerly known as Shared Image Gallery).

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Compute/galleries` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries) |
| `Microsoft.Compute/galleries/applications` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/applications) |
| `Microsoft.Compute/galleries/images` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/images) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/compute.gallery:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module gallery 'br:bicep/modules/compute.gallery:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cgcom'
  params: {
    // Required parameters
    name: 'cgcom001'
    // Non-required parameters
    applications: [
      {
        name: 'cgcom-appd-001'
      }
      {
        name: 'cgcom-appd-002'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        supportedOSType: 'Windows'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    images: [
      {
        name: 'az-imgd-ws-001'
      }
      {
        hyperVGeneration: 'V1'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-ws-002'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition'
      }
      {
        hyperVGeneration: 'V2'
        isHibernateSupported: 'true'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-ws-003'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition-hibernate'
      }
      {
        hyperVGeneration: 'V2'
        isAcceleratedNetworkSupported: 'true'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-ws-004'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition-accnet'
      }
      {
        hyperVGeneration: 'V2'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 4
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-wdtl-002'
        offer: 'WindowsDesktop'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsDesktop'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        securityType: 'TrustedLaunch'
        sku: 'Win11-21H2'
      }
      {
        hyperVGeneration: 'V2'
        maxRecommendedMemory: 32
        maxRecommendedvCPUs: 4
        minRecommendedMemory: 4
        minRecommendedvCPUs: 1
        name: 'az-imgd-us-001'
        offer: '0001-com-ubuntu-server-focal'
        osState: 'Generalized'
        osType: 'Linux'
        publisher: 'canonical'
        sku: '20_04-lts-gen2'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
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
      "value": "cgcom001"
    },
    // Non-required parameters
    "applications": {
      "value": [
        {
          "name": "cgcom-appd-001"
        },
        {
          "name": "cgcom-appd-002",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "supportedOSType": "Windows"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "images": {
      "value": [
        {
          "name": "az-imgd-ws-001"
        },
        {
          "hyperVGeneration": "V1",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-ws-002",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition"
        },
        {
          "hyperVGeneration": "V2",
          "isHibernateSupported": "true",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-ws-003",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition-hibernate"
        },
        {
          "hyperVGeneration": "V2",
          "isAcceleratedNetworkSupported": "true",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-ws-004",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition-accnet"
        },
        {
          "hyperVGeneration": "V2",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 4,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-wdtl-002",
          "offer": "WindowsDesktop",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsDesktop",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "securityType": "TrustedLaunch",
          "sku": "Win11-21H2"
        },
        {
          "hyperVGeneration": "V2",
          "maxRecommendedMemory": 32,
          "maxRecommendedvCPUs": 4,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 1,
          "name": "az-imgd-us-001",
          "offer": "0001-com-ubuntu-server-focal",
          "osState": "Generalized",
          "osType": "Linux",
          "publisher": "canonical",
          "sku": "20_04-lts-gen2"
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
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
    }
  }
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module gallery 'br:bicep/modules/compute.gallery:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cgmin'
  params: {
    // Required parameters
    name: 'cgmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
      "value": "cgmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
| [`name`](#parameter-name) | string | Name of the Azure Compute Gallery. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applications`](#parameter-applications) | array | Applications to create. |
| [`description`](#parameter-description) | string | Description of the Azure Shared Image Gallery. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`images`](#parameter-images) | array | Images to create. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags for all resources. |

### Parameter: `applications`

Applications to create.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `description`

Description of the Azure Shared Image Gallery.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `images`

Images to create.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all resources.
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

### Parameter: `name`

Name of the Azure Compute Gallery.
- Required: Yes
- Type: string

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

### Parameter: `tags`

Tags for all resources.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed image gallery. |
| `resourceGroupName` | string | The resource group of the deployed image gallery. |
| `resourceId` | string | The resource ID of the deployed image gallery. |

## Cross-referenced modules

_None_
