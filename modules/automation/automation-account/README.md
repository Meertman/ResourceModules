# Automation Accounts `[Microsoft.Automation/automationAccounts]`

This module deploys an Azure Automation Account.

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
| `Microsoft.Automation/automationAccounts` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts) |
| `Microsoft.Automation/automationAccounts/jobSchedules` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/jobSchedules) |
| `Microsoft.Automation/automationAccounts/modules` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/modules) |
| `Microsoft.Automation/automationAccounts/runbooks` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/runbooks) |
| `Microsoft.Automation/automationAccounts/schedules` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/schedules) |
| `Microsoft.Automation/automationAccounts/softwareUpdateConfigurations` | [2019-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2019-06-01/automationAccounts/softwareUpdateConfigurations) |
| `Microsoft.Automation/automationAccounts/variables` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/variables) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/automation.automation-account:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Encr](#example-2-encr)
- [Using only defaults](#example-3-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module automationAccount 'br:bicep/modules/automation.automation-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-aacom'
  params: {
    // Required parameters
    name: 'aacom001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    disableLocalAuth: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    gallerySolutions: [
      {
        name: 'Updates'
        product: 'OMSGallery'
        publisher: 'Microsoft'
      }
    ]
    jobSchedules: [
      {
        runbookName: 'TestRunbook'
        scheduleName: 'TestSchedule'
      }
    ]
    linkedWorkspaceResourceId: '<linkedWorkspaceResourceId>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    modules: [
      {
        name: 'PSWindowsUpdate'
        uri: 'https://www.powershellgallery.com/api/v2/package'
        version: 'latest'
      }
    ]
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        service: 'Webhook'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        service: 'DSCAndHybridWorker'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    runbooks: [
      {
        description: 'Test runbook'
        name: 'TestRunbook'
        type: 'PowerShell'
        uri: 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.automation/101-automation/scripts/AzureAutomationTutorial.ps1'
        version: '1.0.0.0'
      }
    ]
    schedules: [
      {
        advancedSchedule: {}
        expiryTime: '9999-12-31T13:00'
        frequency: 'Hour'
        interval: 12
        name: 'TestSchedule'
        startTime: ''
        timeZone: 'Europe/Berlin'
      }
    ]
    softwareUpdateConfigurations: [
      {
        excludeUpdates: [
          '123456'
        ]
        frequency: 'Month'
        includeUpdates: [
          '654321'
        ]
        interval: 1
        maintenanceWindow: 'PT4H'
        monthlyOccurrences: [
          {
            day: 'Friday'
            occurrence: 3
          }
        ]
        name: 'Windows_ZeroDay'
        operatingSystem: 'Windows'
        rebootSetting: 'IfRequired'
        scopeByTags: {
          Update: [
            'Automatic-Wave1'
          ]
        }
        startTime: '22:00'
        updateClassifications: [
          'Critical'
          'Definition'
          'FeaturePack'
          'Security'
          'ServicePack'
          'Tools'
          'UpdateRollup'
          'Updates'
        ]
      }
      {
        excludeUpdates: [
          'icacls'
        ]
        frequency: 'OneTime'
        includeUpdates: [
          'kernel'
        ]
        maintenanceWindow: 'PT4H'
        name: 'Linux_ZeroDay'
        operatingSystem: 'Linux'
        rebootSetting: 'IfRequired'
        startTime: '22:00'
        updateClassifications: [
          'Critical'
          'Other'
          'Security'
        ]
      }
    ]
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    variables: [
      {
        description: 'TestStringDescription'
        name: 'TestString'
        value: '\'TestString\''
      }
      {
        description: 'TestIntegerDescription'
        name: 'TestInteger'
        value: '500'
      }
      {
        description: 'TestBooleanDescription'
        name: 'TestBoolean'
        value: 'false'
      }
      {
        description: 'TestDateTimeDescription'
        isEncrypted: false
        name: 'TestDateTime'
        value: '\'\\/Date(1637934042656)\\/\''
      }
      {
        description: 'TestEncryptedDescription'
        name: 'TestEncryptedVariable'
        value: '\'TestEncryptedValue\''
      }
    ]
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
      "value": "aacom001"
    },
    // Non-required parameters
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
    "gallerySolutions": {
      "value": [
        {
          "name": "Updates",
          "product": "OMSGallery",
          "publisher": "Microsoft"
        }
      ]
    },
    "jobSchedules": {
      "value": [
        {
          "runbookName": "TestRunbook",
          "scheduleName": "TestSchedule"
        }
      ]
    },
    "linkedWorkspaceResourceId": {
      "value": "<linkedWorkspaceResourceId>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "modules": {
      "value": [
        {
          "name": "PSWindowsUpdate",
          "uri": "https://www.powershellgallery.com/api/v2/package",
          "version": "latest"
        }
      ]
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "service": "Webhook",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "service": "DSCAndHybridWorker",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
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
    "runbooks": {
      "value": [
        {
          "description": "Test runbook",
          "name": "TestRunbook",
          "type": "PowerShell",
          "uri": "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.automation/101-automation/scripts/AzureAutomationTutorial.ps1",
          "version": "1.0.0.0"
        }
      ]
    },
    "schedules": {
      "value": [
        {
          "advancedSchedule": {},
          "expiryTime": "9999-12-31T13:00",
          "frequency": "Hour",
          "interval": 12,
          "name": "TestSchedule",
          "startTime": "",
          "timeZone": "Europe/Berlin"
        }
      ]
    },
    "softwareUpdateConfigurations": {
      "value": [
        {
          "excludeUpdates": [
            "123456"
          ],
          "frequency": "Month",
          "includeUpdates": [
            "654321"
          ],
          "interval": 1,
          "maintenanceWindow": "PT4H",
          "monthlyOccurrences": [
            {
              "day": "Friday",
              "occurrence": 3
            }
          ],
          "name": "Windows_ZeroDay",
          "operatingSystem": "Windows",
          "rebootSetting": "IfRequired",
          "scopeByTags": {
            "Update": [
              "Automatic-Wave1"
            ]
          },
          "startTime": "22:00",
          "updateClassifications": [
            "Critical",
            "Definition",
            "FeaturePack",
            "Security",
            "ServicePack",
            "Tools",
            "UpdateRollup",
            "Updates"
          ]
        },
        {
          "excludeUpdates": [
            "icacls"
          ],
          "frequency": "OneTime",
          "includeUpdates": [
            "kernel"
          ],
          "maintenanceWindow": "PT4H",
          "name": "Linux_ZeroDay",
          "operatingSystem": "Linux",
          "rebootSetting": "IfRequired",
          "startTime": "22:00",
          "updateClassifications": [
            "Critical",
            "Other",
            "Security"
          ]
        }
      ]
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
    "variables": {
      "value": [
        {
          "description": "TestStringDescription",
          "name": "TestString",
          "value": "\"TestString\""
        },
        {
          "description": "TestIntegerDescription",
          "name": "TestInteger",
          "value": "500"
        },
        {
          "description": "TestBooleanDescription",
          "name": "TestBoolean",
          "value": "false"
        },
        {
          "description": "TestDateTimeDescription",
          "isEncrypted": false,
          "name": "TestDateTime",
          "value": "\"\\/Date(1637934042656)\\/\""
        },
        {
          "description": "TestEncryptedDescription",
          "name": "TestEncryptedVariable",
          "value": "\"TestEncryptedValue\""
        }
      ]
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
module automationAccount 'br:bicep/modules/automation.automation-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-aaencr'
  params: {
    // Required parameters
    name: 'aaencr001'
    // Non-required parameters
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
      "value": "aaencr001"
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
module automationAccount 'br:bicep/modules/automation.automation-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-aamin'
  params: {
    // Required parameters
    name: 'aamin001'
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
      "value": "aamin001"
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
| [`name`](#parameter-name) | string | Name of the Automation Account. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cMKKeyVaultResourceId`](#parameter-cmkkeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |
| [`cMKUserAssignedIdentityResourceId`](#parameter-cmkuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if 'cMKKeyName' is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cMKKeyName`](#parameter-cmkkeyname) | string | The name of the customer managed key to use for encryption. |
| [`cMKKeyVersion`](#parameter-cmkkeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | Disable local authentication profile used within the resource. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`gallerySolutions`](#parameter-gallerysolutions) | array | List of gallerySolutions to be created in the linked log analytics workspace. |
| [`jobSchedules`](#parameter-jobschedules) | array | List of jobSchedules to be created in the automation account. |
| [`linkedWorkspaceResourceId`](#parameter-linkedworkspaceresourceid) | string | ID of the log analytics workspace to be linked to the deployed automation account. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`modules`](#parameter-modules) | array | List of modules to be created in the automation account. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`runbooks`](#parameter-runbooks) | array | List of runbooks to be created in the automation account. |
| [`schedules`](#parameter-schedules) | array | List of schedules to be created in the automation account. |
| [`skuName`](#parameter-skuname) | string | SKU name of the account. |
| [`softwareUpdateConfigurations`](#parameter-softwareupdateconfigurations) | array | List of softwareUpdateConfigurations to be created in the automation account. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the Automation Account resource. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |
| [`variables`](#parameter-variables) | array | List of variables to be created in the automation account. |

### Parameter: `cMKKeyName`

The name of the customer managed key to use for encryption.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKKeyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKKeyVersion`

The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKUserAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if 'cMKKeyName' is not empty.
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
- Allowed: `['', allLogs, DscNodeStatus, JobLogs, JobStreams]`

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

Disable local authentication profile used within the resource.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `gallerySolutions`

List of gallerySolutions to be created in the linked log analytics workspace.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `jobSchedules`

List of jobSchedules to be created in the automation account.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `linkedWorkspaceResourceId`

ID of the log analytics workspace to be linked to the deployed automation account.
- Required: No
- Type: string
- Default: `''`

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

### Parameter: `modules`

List of modules to be created in the automation account.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `name`

Name of the Automation Account.
- Required: Yes
- Type: string

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
| [`service`](#parameter-privateendpointsservice) | Yes | string | Required. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob". |
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

Required. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".

- Required: Yes
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
- Allowed: `['', Disabled, Enabled]`

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

### Parameter: `runbooks`

List of runbooks to be created in the automation account.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `schedules`

List of schedules to be created in the automation account.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `skuName`

SKU name of the account.
- Required: No
- Type: string
- Default: `'Basic'`
- Allowed: `[Basic, Free]`

### Parameter: `softwareUpdateConfigurations`

List of softwareUpdateConfigurations to be created in the automation account.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the Automation Account resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `variables`

List of variables to be created in the automation account.
- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed automation account. |
| `resourceGroupName` | string | The resource group of the deployed automation account. |
| `resourceId` | string | The resource ID of the deployed automation account. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |
| `modules/operational-insights/workspace/linked-service` | Local reference |
| `modules/operations-management/solution` | Local reference |
