# Event Hub Namespaces `[Microsoft.EventHub/namespaces]`

This module deploys an Event Hub Namespace.

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
| `Microsoft.EventHub/namespaces` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces) |
| `Microsoft.EventHub/namespaces/authorizationRules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/authorizationRules) |
| `Microsoft.EventHub/namespaces/disasterRecoveryConfigs` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/disasterRecoveryConfigs) |
| `Microsoft.EventHub/namespaces/eventhubs` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/eventhubs) |
| `Microsoft.EventHub/namespaces/eventhubs/authorizationRules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/eventhubs/authorizationRules) |
| `Microsoft.EventHub/namespaces/eventhubs/consumergroups` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/eventhubs/consumergroups) |
| `Microsoft.EventHub/namespaces/networkRuleSets` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/networkRuleSets) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/event-hub.namespace:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Encr](#example-2-encr)
- [Using only defaults](#example-3-using-only-defaults)
- [Pe](#example-4-pe)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br:bicep/modules/event-hub.namespace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ehncom'
  params: {
    // Required parameters
    name: 'ehncom001'
    // Non-required parameters
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
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    disableLocalAuth: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    eventhubs: [
      {
        name: 'az-evh-x-001'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
      }
      {
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
        captureDescriptionDestinationStorageAccountResourceId: '<captureDescriptionDestinationStorageAccountResourceId>'
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
        name: 'az-evh-x-002'
        partitionCount: 2
        retentionDescriptionCleanupPolicy: 'Delete'
        retentionDescriptionRetentionTimeInHours: 3
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        status: 'Active'
      }
      {
        name: 'az-evh-x-003'
        retentionDescriptionCleanupPolicy: 'Compact'
        retentionDescriptionTombstoneRetentionTimeInHours: 24
      }
    ]
    isAutoInflateEnabled: true
    kafkaEnabled: true
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maximumThroughputUnits: 4
    minimumTlsVersion: '1.2'
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
          subnetResourceId: '<subnetResourceId>'
        }
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        service: 'namespace'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    publicNetworkAccess: 'Disabled'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    skuCapacity: 2
    skuName: 'Standard'
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    zoneRedundant: true
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
      "value": "ehncom001"
    },
    // Non-required parameters
    "authorizationRules": {
      "value": [
        {
          "name": "RootManageSharedAccessKey",
          "rights": [
            "Listen",
            "Manage",
            "Send"
          ]
        },
        {
          "name": "SendListenAccess",
          "rights": [
            "Listen",
            "Send"
          ]
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
    "disableLocalAuth": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "eventhubs": {
      "value": [
        {
          "name": "az-evh-x-001",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ]
        },
        {
          "authorizationRules": [
            {
              "name": "RootManageSharedAccessKey",
              "rights": [
                "Listen",
                "Manage",
                "Send"
              ]
            },
            {
              "name": "SendListenAccess",
              "rights": [
                "Listen",
                "Send"
              ]
            }
          ],
          "captureDescriptionDestinationArchiveNameFormat": "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}",
          "captureDescriptionDestinationBlobContainer": "eventhub",
          "captureDescriptionDestinationName": "EventHubArchive.AzureBlockBlob",
          "captureDescriptionDestinationStorageAccountResourceId": "<captureDescriptionDestinationStorageAccountResourceId>",
          "captureDescriptionEnabled": true,
          "captureDescriptionEncoding": "Avro",
          "captureDescriptionIntervalInSeconds": 300,
          "captureDescriptionSizeLimitInBytes": 314572800,
          "captureDescriptionSkipEmptyArchives": true,
          "consumergroups": [
            {
              "name": "custom",
              "userMetadata": "customMetadata"
            }
          ],
          "messageRetentionInDays": 1,
          "name": "az-evh-x-002",
          "partitionCount": 2,
          "retentionDescriptionCleanupPolicy": "Delete",
          "retentionDescriptionRetentionTimeInHours": 3,
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "status": "Active"
        },
        {
          "name": "az-evh-x-003",
          "retentionDescriptionCleanupPolicy": "Compact",
          "retentionDescriptionTombstoneRetentionTimeInHours": 24
        }
      ]
    },
    "isAutoInflateEnabled": {
      "value": true
    },
    "kafkaEnabled": {
      "value": true
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "maximumThroughputUnits": {
      "value": 4
    },
    "minimumTlsVersion": {
      "value": "1.2"
    },
    "networkRuleSets": {
      "value": {
        "defaultAction": "Deny",
        "ipRules": [
          {
            "action": "Allow",
            "ipMask": "10.10.10.10"
          }
        ],
        "trustedServiceAccessEnabled": false,
        "virtualNetworkRules": [
          {
            "ignoreMissingVnetServiceEndpoint": true,
            "subnetResourceId": "<subnetResourceId>"
          }
        ]
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "service": "namespace",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "publicNetworkAccess": {
      "value": "Disabled"
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
    "skuCapacity": {
      "value": 2
    },
    "skuName": {
      "value": "Standard"
    },
    "systemAssignedIdentity": {
      "value": true
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
    },
    "zoneRedundant": {
      "value": true
    }
  }
}
```

</details>
<p>

### Example 2: _Encr_

<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br:bicep/modules/event-hub.namespace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ehnenc'
  params: {
    // Required parameters
    name: 'ehnenc001'
    // Non-required parameters
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    publicNetworkAccess: 'SecuredByPerimeter'
    requireInfrastructureEncryption: true
    skuName: 'Premium'
    systemAssignedIdentity: false
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
      "value": "ehnenc001"
    },
    // Non-required parameters
    "cMKKeyName": {
      "value": "<cMKKeyName>"
    },
    "cMKKeyVaultResourceId": {
      "value": "<cMKKeyVaultResourceId>"
    },
    "cMKUserAssignedIdentityResourceId": {
      "value": "<cMKUserAssignedIdentityResourceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "publicNetworkAccess": {
      "value": "SecuredByPerimeter"
    },
    "requireInfrastructureEncryption": {
      "value": true
    },
    "skuName": {
      "value": "Premium"
    },
    "systemAssignedIdentity": {
      "value": false
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
module namespace 'br:bicep/modules/event-hub.namespace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ehnmin'
  params: {
    // Required parameters
    name: 'ehnmin001'
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
      "value": "ehnmin001"
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

### Example 4: _Pe_

<details>

<summary>via Bicep module</summary>

```bicep
module namespace 'br:bicep/modules/event-hub.namespace:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ehnpe'
  params: {
    // Required parameters
    name: 'ehnpe001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    skuCapacity: 2
    skuName: 'Premium'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    zoneRedundant: true
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
      "value": "ehnpe001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "skuCapacity": {
      "value": 2
    },
    "skuName": {
      "value": "Premium"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "zoneRedundant": {
      "value": true
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
| [`name`](#parameter-name) | string | The name of the event hub namespace. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cMKKeyVaultResourceId`](#parameter-cmkkeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. Required if "cMKKeyName" is not empty. |
| [`cMKUserAssignedIdentityResourceId`](#parameter-cmkuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. The identity should have key usage permissions on the Key Vault Key. Required if "cMKKeyName" is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationRules`](#parameter-authorizationrules) | array | Authorization Rules for the Event Hub namespace. |
| [`cMKKeyName`](#parameter-cmkkeyname) | string | The name of the customer managed key to use for encryption. Customer-managed key encryption at rest is only available for namespaces of premium SKU or namespaces created in a Dedicated Cluster. |
| [`cMKKeyVersion`](#parameter-cmkkeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | This property disables SAS authentication for the Event Hubs namespace. |
| [`disasterRecoveryConfig`](#parameter-disasterrecoveryconfig) | object | The disaster recovery config for this namespace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`eventhubs`](#parameter-eventhubs) | array | The event hubs to deploy into this namespace. |
| [`isAutoInflateEnabled`](#parameter-isautoinflateenabled) | bool | Switch to enable the Auto Inflate feature of Event Hub. Auto Inflate is not supported in Premium SKU EventHub. |
| [`kafkaEnabled`](#parameter-kafkaenabled) | bool | Value that indicates whether Kafka is enabled for Event Hubs Namespace. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maximumThroughputUnits`](#parameter-maximumthroughputunits) | int | Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units. |
| [`minimumTlsVersion`](#parameter-minimumtlsversion) | string | The minimum TLS version for the cluster to support. |
| [`networkRuleSets`](#parameter-networkrulesets) | object | Configure networking options. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`requireInfrastructureEncryption`](#parameter-requireinfrastructureencryption) | bool | Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`skuCapacity`](#parameter-skucapacity) | int | The Event Hub's throughput units for Basic or Standard tiers, where value should be 0 to 20 throughput units. The Event Hubs premium units for Premium tier, where value should be 0 to 10 premium units. |
| [`skuName`](#parameter-skuname) | string | event hub plan SKU name. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Switch to make the Event Hub Namespace zone redundant. |

### Parameter: `authorizationRules`

Authorization Rules for the Event Hub namespace.
- Required: No
- Type: array
- Default: `[System.Management.Automation.OrderedHashtable]`

### Parameter: `cMKKeyName`

The name of the customer managed key to use for encryption. Customer-managed key encryption at rest is only available for namespaces of premium SKU or namespaces created in a Dedicated Cluster.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKKeyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from. Required if "cMKKeyName" is not empty.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKKeyVersion`

The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKUserAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. The identity should have key usage permissions on the Key Vault Key. Required if "cMKKeyName" is not empty.
- Required: No
- Type: string
- Default: `''`

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
- Allowed: `['', allLogs, ApplicationMetricsLogs, ArchiveLogs, AutoScaleLogs, CustomerManagedKeyUserLogs, EventHubVNetConnectionEvent, KafkaCoordinatorLogs, KafkaUserErrorLogs, OperationalLogs, RuntimeAuditLogs]`

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

### Parameter: `disableLocalAuth`

This property disables SAS authentication for the Event Hubs namespace.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `disasterRecoveryConfig`

The disaster recovery config for this namespace.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `eventhubs`

The event hubs to deploy into this namespace.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `isAutoInflateEnabled`

Switch to enable the Auto Inflate feature of Event Hub. Auto Inflate is not supported in Premium SKU EventHub.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `kafkaEnabled`

Value that indicates whether Kafka is enabled for Event Hubs Namespace.
- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `maximumThroughputUnits`

Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units.
- Required: No
- Type: int
- Default: `1`

### Parameter: `minimumTlsVersion`

The minimum TLS version for the cluster to support.
- Required: No
- Type: string
- Default: `'1.2'`
- Allowed: `[1.0, 1.1, 1.2]`

### Parameter: `name`

The name of the event hub namespace.
- Required: Yes
- Type: string

### Parameter: `networkRuleSets`

Configure networking options. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | No | array | Optional. Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | No | array | Optional. Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | No | string | Optional. The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | No | bool | Optional. Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | No | array | Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`location`](#parameter-privateendpointslocation) | No | string | Optional. The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | No | object | Optional. Specify the type of lock. |
| [`manualPrivateLinkServiceConnections`](#parameter-privateendpointsmanualprivatelinkserviceconnections) | No | array | Optional. Manual PrivateLink Service Connections. |
| [`name`](#parameter-privateendpointsname) | No | string | Optional. The name of the private endpoint. |
| [`privateDnsZoneGroupName`](#parameter-privateendpointsprivatednszonegroupname) | No | string | Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privateendpointsprivatednszoneresourceids) | No | array | Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | No | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`service`](#parameter-privateendpointsservice) | No | string | Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob". |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | Yes | string | Required. Resource ID of the subnet where the endpoint needs to be created. |
| [`tags`](#parameter-privateendpointstags) | No | object | Optional. Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Optional. Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Optional. Custom DNS configurations.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | No | string |  |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | Yes | array |  |

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`
- Required: No
- Type: string

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`
- Required: Yes
- Type: array


### Parameter: `privateEndpoints.customNetworkInterfaceName`

Optional. The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Optional. Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationsgroupid) | Yes | string |  |
| [`memberName`](#parameter-privateendpointsipconfigurationsmembername) | Yes | string |  |
| [`name`](#parameter-privateendpointsipconfigurationsname) | Yes | string |  |
| [`privateIpAddress`](#parameter-privateendpointsipconfigurationsprivateipaddress) | Yes | string |  |

### Parameter: `privateEndpoints.ipConfigurations.groupId`
- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.memberName`
- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.name`
- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.privateIpAddress`
- Required: Yes
- Type: string


### Parameter: `privateEndpoints.location`

Optional. The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Optional. Specify the type of lock.

- Required: No
- Type: object

### Parameter: `privateEndpoints.manualPrivateLinkServiceConnections`

Optional. Manual PrivateLink Service Connections.

- Required: No
- Type: array

### Parameter: `privateEndpoints.name`

Optional. The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroupName`

Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneResourceIds`

Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.

- Required: No
- Type: array

### Parameter: `privateEndpoints.roleAssignments`

Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: No
- Type: array

### Parameter: `privateEndpoints.service`

Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".

- Required: No
- Type: string

### Parameter: `privateEndpoints.subnetResourceId`

Required. Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.tags`

Optional. Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Disabled, Enabled, SecuredByPerimeter]`

### Parameter: `requireInfrastructureEncryption`

Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.
- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `skuCapacity`

The Event Hub's throughput units for Basic or Standard tiers, where value should be 0 to 20 throughput units. The Event Hubs premium units for Premium tier, where value should be 0 to 10 premium units.
- Required: No
- Type: int
- Default: `1`

### Parameter: `skuName`

event hub plan SKU name.
- Required: No
- Type: string
- Default: `'Standard'`
- Allowed: `[Basic, Premium, Standard]`

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

### Parameter: `zoneRedundant`

Switch to make the Event Hub Namespace zone redundant.
- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the eventspace. |
| `resourceGroupName` | string | The resource group where the namespace is deployed. |
| `resourceId` | string | The resource ID of the eventspace. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |
