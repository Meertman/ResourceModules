# DBforMySQL Flexible Servers `[Microsoft.DBforMySQL/flexibleServers]`

This module deploys a DBforMySQL Flexible Server.

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
| `Microsoft.DBforMySQL/flexibleServers` | [2022-09-30-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2022-09-30-preview/flexibleServers) |
| `Microsoft.DBforMySQL/flexibleServers/administrators` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2022-01-01/flexibleServers/administrators) |
| `Microsoft.DBforMySQL/flexibleServers/databases` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2022-01-01/flexibleServers/databases) |
| `Microsoft.DBforMySQL/flexibleServers/firewallRules` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2022-01-01/flexibleServers/firewallRules) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/db-for-my-sql.flexible-server:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Private](#example-2-private)
- [Public](#example-3-public)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br:bicep/modules/db-for-my-sql.flexible-server:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dfmsfsmin'
  params: {
    // Required parameters
    name: 'dfmsfsmin001'
    skuName: 'Standard_B1ms'
    tier: 'Burstable'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
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
      "value": "dfmsfsmin001"
    },
    "skuName": {
      "value": "Standard_B1ms"
    },
    "tier": {
      "value": "Burstable"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

### Example 2: _Private_

<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br:bicep/modules/db-for-my-sql.flexible-server:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dfmsfspvt'
  params: {
    // Required parameters
    name: 'dfmsfspvt001'
    skuName: 'Standard_D2ds_v4'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    administrators: [
      {
        identityResourceId: '<identityResourceId>'
        login: '<login>'
        sid: '<sid>'
      }
    ]
    backupRetentionDays: 10
    databases: [
      {
        name: 'testdb1'
      }
    ]
    delegatedSubnetResourceId: '<delegatedSubnetResourceId>'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    highAvailability: 'SameZone'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    storageAutoGrow: 'Enabled'
    storageAutoIoScaling: 'Enabled'
    storageIOPS: 400
    storageSizeGB: 64
    tags: {
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'MySQL Flexible Server'
      serverName: 'dfmsfspvt001'
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
      "value": "dfmsfspvt001"
    },
    "skuName": {
      "value": "Standard_D2ds_v4"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "administrators": {
      "value": [
        {
          "identityResourceId": "<identityResourceId>",
          "login": "<login>",
          "sid": "<sid>"
        }
      ]
    },
    "backupRetentionDays": {
      "value": 10
    },
    "databases": {
      "value": [
        {
          "name": "testdb1"
        }
      ]
    },
    "delegatedSubnetResourceId": {
      "value": "<delegatedSubnetResourceId>"
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
    "highAvailability": {
      "value": "SameZone"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "privateDnsZoneResourceId": {
      "value": "<privateDnsZoneResourceId>"
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
    "storageAutoGrow": {
      "value": "Enabled"
    },
    "storageAutoIoScaling": {
      "value": "Enabled"
    },
    "storageIOPS": {
      "value": 400
    },
    "storageSizeGB": {
      "value": 64
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "resourceType": "MySQL Flexible Server",
        "serverName": "dfmsfspvt001"
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

### Example 3: _Public_

<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br:bicep/modules/db-for-my-sql.flexible-server:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dfmsfsp'
  params: {
    // Required parameters
    name: 'dfmsfsp001'
    skuName: 'Standard_D2ds_v4'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    availabilityZone: '1'
    backupRetentionDays: 20
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
    databases: [
      {
        name: 'testdb1'
      }
      {
        charset: 'ascii'
        collation: 'ascii_general_ci'
        name: 'testdb2'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    firewallRules: [
      {
        endIpAddress: '0.0.0.0'
        name: 'AllowAllWindowsAzureIps'
        startIpAddress: '0.0.0.0'
      }
      {
        endIpAddress: '10.10.10.10'
        name: 'test-rule1'
        startIpAddress: '10.10.10.1'
      }
      {
        endIpAddress: '100.100.100.10'
        name: 'test-rule2'
        startIpAddress: '100.100.100.1'
      }
    ]
    geoBackupCMKKeyName: '<geoBackupCMKKeyName>'
    geoBackupCMKKeyVaultResourceId: '<geoBackupCMKKeyVaultResourceId>'
    geoBackupCMKUserAssignedIdentityResourceId: '<geoBackupCMKUserAssignedIdentityResourceId>'
    geoRedundantBackup: 'Enabled'
    highAvailability: 'SameZone'
    location: '<location>'
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
    storageAutoGrow: 'Enabled'
    storageAutoIoScaling: 'Enabled'
    storageIOPS: 400
    storageSizeGB: 32
    tags: {
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'MySQL Flexible Server'
      serverName: 'dfmsfsp001'
    }
    userAssignedIdentities: {
      '<geoBackupManagedIdentityResourceId>': {}
      '<managedIdentityResourceId>': {}
    }
    version: '8.0.21'
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
      "value": "dfmsfsp001"
    },
    "skuName": {
      "value": "Standard_D2ds_v4"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "availabilityZone": {
      "value": "1"
    },
    "backupRetentionDays": {
      "value": 20
    },
    "cMKKeyName": {
      "value": "<cMKKeyName>"
    },
    "cMKKeyVaultResourceId": {
      "value": "<cMKKeyVaultResourceId>"
    },
    "cMKUserAssignedIdentityResourceId": {
      "value": "<cMKUserAssignedIdentityResourceId>"
    },
    "databases": {
      "value": [
        {
          "name": "testdb1"
        },
        {
          "charset": "ascii",
          "collation": "ascii_general_ci",
          "name": "testdb2"
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
    "firewallRules": {
      "value": [
        {
          "endIpAddress": "0.0.0.0",
          "name": "AllowAllWindowsAzureIps",
          "startIpAddress": "0.0.0.0"
        },
        {
          "endIpAddress": "10.10.10.10",
          "name": "test-rule1",
          "startIpAddress": "10.10.10.1"
        },
        {
          "endIpAddress": "100.100.100.10",
          "name": "test-rule2",
          "startIpAddress": "100.100.100.1"
        }
      ]
    },
    "geoBackupCMKKeyName": {
      "value": "<geoBackupCMKKeyName>"
    },
    "geoBackupCMKKeyVaultResourceId": {
      "value": "<geoBackupCMKKeyVaultResourceId>"
    },
    "geoBackupCMKUserAssignedIdentityResourceId": {
      "value": "<geoBackupCMKUserAssignedIdentityResourceId>"
    },
    "geoRedundantBackup": {
      "value": "Enabled"
    },
    "highAvailability": {
      "value": "SameZone"
    },
    "location": {
      "value": "<location>"
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
    "storageAutoGrow": {
      "value": "Enabled"
    },
    "storageAutoIoScaling": {
      "value": "Enabled"
    },
    "storageIOPS": {
      "value": 400
    },
    "storageSizeGB": {
      "value": 32
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "resourceType": "MySQL Flexible Server",
        "serverName": "dfmsfsp001"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<geoBackupManagedIdentityResourceId>": {},
        "<managedIdentityResourceId>": {}
      }
    },
    "version": {
      "value": "8.0.21"
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
| [`name`](#parameter-name) | string | The name of the MySQL flexible server. |
| [`skuName`](#parameter-skuname) | string | The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3. |
| [`tier`](#parameter-tier) | string | The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3". |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cMKKeyVaultResourceId`](#parameter-cmkkeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. Required if "cMKKeyName" is not empty. |
| [`cMKUserAssignedIdentityResourceId`](#parameter-cmkuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. The identity should have key usage permissions on the Key Vault Key. Required if "cMKKeyName" is not empty. |
| [`geoBackupCMKKeyVaultResourceId`](#parameter-geobackupcmkkeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. Required if "cMKKeyName" is not empty and geoRedundantBackup is "Enabled". |
| [`geoBackupCMKUserAssignedIdentityResourceId`](#parameter-geobackupcmkuserassignedidentityresourceid) | string | Geo backup user identity resource ID as identity cant cross region, need identity in same region as geo backup. The identity should have key usage permissions on the Key Vault Key. Required if "cMKKeyName" is not empty and geoRedundantBackup is "Enabled". |
| [`privateDnsZoneResourceId`](#parameter-privatednszoneresourceid) | string | Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access". Required if "delegatedSubnetResourceId" is used and the Private DNS Zone name must end with mysql.database.azure.com in order to be linked to the MySQL Flexible Server. |
| [`restorePointInTime`](#parameter-restorepointintime) | string | Restore point creation time (ISO8601 format), specifying the time to restore from. Required if "createMode" is set to "PointInTimeRestore". |
| [`sourceServerResourceId`](#parameter-sourceserverresourceid) | string | The source MySQL server ID. Required if "createMode" is set to "PointInTimeRestore". |
| [`storageAutoGrow`](#parameter-storageautogrow) | string | Enable Storage Auto Grow or not. Storage auto-growth prevents a server from running out of storage and becoming read-only. Required if "highAvailability" is not "Disabled". |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. Required if "cMKKeyName" is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorLogin`](#parameter-administratorlogin) | string | The administrator login name of a server. Can only be specified when the MySQL server is being created. |
| [`administratorLoginPassword`](#parameter-administratorloginpassword) | securestring | The administrator login password. |
| [`administrators`](#parameter-administrators) | array | The Azure AD administrators when AAD authentication enabled. |
| [`availabilityZone`](#parameter-availabilityzone) | string | Availability zone information of the server. Default will have no preference set. |
| [`backupRetentionDays`](#parameter-backupretentiondays) | int | Backup retention days for the server. |
| [`cMKKeyName`](#parameter-cmkkeyname) | string | The name of the customer managed key to use for encryption. |
| [`cMKKeyVersion`](#parameter-cmkkeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| [`createMode`](#parameter-createmode) | string | The mode to create a new MySQL server. |
| [`databases`](#parameter-databases) | array | The databases to create in the server. |
| [`delegatedSubnetResourceId`](#parameter-delegatedsubnetresourceid) | string | Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration. Delegation must be enabled on the subnet for MySQL Flexible Servers and subnet CIDR size is /29. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`firewallRules`](#parameter-firewallrules) | array | The firewall rules to create in the MySQL flexible server. |
| [`geoBackupCMKKeyName`](#parameter-geobackupcmkkeyname) | string | The name of the customer managed key to use for encryption when geoRedundantBackup is "Enabled". |
| [`geoBackupCMKKeyVersion`](#parameter-geobackupcmkkeyversion) | string | The version of the customer managed key to reference for encryption when geoRedundantBackup is "Enabled". If not provided, the latest key version is used. |
| [`geoRedundantBackup`](#parameter-georedundantbackup) | string | A value indicating whether Geo-Redundant backup is enabled on the server. If "Enabled" and "cMKKeyName" is not empty, then "geoBackupCMKKeyVaultResourceId" and "cMKUserAssignedIdentityResourceId" are also required. |
| [`highAvailability`](#parameter-highavailability) | string | The mode for High Availability (HA). It is not supported for the Burstable pricing tier and Zone redundant HA can only be set during server provisioning. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maintenanceWindow`](#parameter-maintenancewindow) | object | Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled". |
| [`replicationRole`](#parameter-replicationrole) | string | The replication role. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11". |
| [`storageAutoIoScaling`](#parameter-storageautoioscaling) | string | Enable IO Auto Scaling or not. The server scales IOPs up or down automatically depending on your workload needs. |
| [`storageIOPS`](#parameter-storageiops) | int | Storage IOPS for a server. Max IOPS are determined by compute size. |
| [`storageSizeGB`](#parameter-storagesizegb) | int | Max storage allowed for a server. In all compute tiers, the minimum storage supported is 20 GiB and maximum is 16 TiB. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`version`](#parameter-version) | string | MySQL Server version. |

### Parameter: `administratorLogin`

The administrator login name of a server. Can only be specified when the MySQL server is being created.
- Required: No
- Type: string
- Default: `''`

### Parameter: `administratorLoginPassword`

The administrator login password.
- Required: No
- Type: securestring
- Default: `''`

### Parameter: `administrators`

The Azure AD administrators when AAD authentication enabled.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `availabilityZone`

Availability zone information of the server. Default will have no preference set.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', 1, 2, 3]`

### Parameter: `backupRetentionDays`

Backup retention days for the server.
- Required: No
- Type: int
- Default: `7`

### Parameter: `cMKKeyName`

The name of the customer managed key to use for encryption.
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

### Parameter: `createMode`

The mode to create a new MySQL server.
- Required: No
- Type: string
- Default: `'Default'`
- Allowed: `[Default, GeoRestore, PointInTimeRestore, Replica]`

### Parameter: `databases`

The databases to create in the server.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `delegatedSubnetResourceId`

Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration. Delegation must be enabled on the subnet for MySQL Flexible Servers and subnet CIDR size is /29.
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
- Allowed: `['', allLogs, MySqlAuditLogs, MySqlSlowLogs]`

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

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `firewallRules`

The firewall rules to create in the MySQL flexible server.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `geoBackupCMKKeyName`

The name of the customer managed key to use for encryption when geoRedundantBackup is "Enabled".
- Required: No
- Type: string
- Default: `''`

### Parameter: `geoBackupCMKKeyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from. Required if "cMKKeyName" is not empty and geoRedundantBackup is "Enabled".
- Required: No
- Type: string
- Default: `''`

### Parameter: `geoBackupCMKKeyVersion`

The version of the customer managed key to reference for encryption when geoRedundantBackup is "Enabled". If not provided, the latest key version is used.
- Required: No
- Type: string
- Default: `''`

### Parameter: `geoBackupCMKUserAssignedIdentityResourceId`

Geo backup user identity resource ID as identity cant cross region, need identity in same region as geo backup. The identity should have key usage permissions on the Key Vault Key. Required if "cMKKeyName" is not empty and geoRedundantBackup is "Enabled".
- Required: No
- Type: string
- Default: `''`

### Parameter: `geoRedundantBackup`

A value indicating whether Geo-Redundant backup is enabled on the server. If "Enabled" and "cMKKeyName" is not empty, then "geoBackupCMKKeyVaultResourceId" and "cMKUserAssignedIdentityResourceId" are also required.
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `highAvailability`

The mode for High Availability (HA). It is not supported for the Burstable pricing tier and Zone redundant HA can only be set during server provisioning.
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed: `[Disabled, SameZone, ZoneRedundant]`

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

### Parameter: `maintenanceWindow`

Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled".
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `name`

The name of the MySQL flexible server.
- Required: Yes
- Type: string

### Parameter: `privateDnsZoneResourceId`

Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access". Required if "delegatedSubnetResourceId" is used and the Private DNS Zone name must end with mysql.database.azure.com in order to be linked to the MySQL Flexible Server.
- Required: No
- Type: string
- Default: `''`

### Parameter: `replicationRole`

The replication role.
- Required: No
- Type: string
- Default: `'None'`
- Allowed: `[None, Replica, Source]`

### Parameter: `restorePointInTime`

Restore point creation time (ISO8601 format), specifying the time to restore from. Required if "createMode" is set to "PointInTimeRestore".
- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11".
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

### Parameter: `skuName`

The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3.
- Required: Yes
- Type: string

### Parameter: `sourceServerResourceId`

The source MySQL server ID. Required if "createMode" is set to "PointInTimeRestore".
- Required: No
- Type: string
- Default: `''`

### Parameter: `storageAutoGrow`

Enable Storage Auto Grow or not. Storage auto-growth prevents a server from running out of storage and becoming read-only. Required if "highAvailability" is not "Disabled".
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `storageAutoIoScaling`

Enable IO Auto Scaling or not. The server scales IOPs up or down automatically depending on your workload needs.
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `storageIOPS`

Storage IOPS for a server. Max IOPS are determined by compute size.
- Required: No
- Type: int
- Default: `1000`

### Parameter: `storageSizeGB`

Max storage allowed for a server. In all compute tiers, the minimum storage supported is 20 GiB and maximum is 16 TiB.
- Required: No
- Type: int
- Default: `64`
- Allowed: `[20, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `tier`

The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3".
- Required: Yes
- Type: string
- Allowed: `[Burstable, GeneralPurpose, MemoryOptimized]`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource. Required if "cMKKeyName" is not empty.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `version`

MySQL Server version.
- Required: No
- Type: string
- Default: `'5.7'`
- Allowed: `[5.7, 8.0.21]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed MySQL Flexible server. |
| `resourceGroupName` | string | The resource group of the deployed MySQL Flexible server. |
| `resourceId` | string | The resource ID of the deployed MySQL Flexible server. |

## Cross-referenced modules

_None_
