# Storage Account blob Services `[Microsoft.Storage/storageAccounts/blobServices]`

This module deploys a Storage Account Blob Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automaticSnapshotPolicyEnabled`](#parameter-automaticsnapshotpolicyenabled) | bool | Automatic Snapshot is enabled if set to true. |
| [`changeFeedEnabled`](#parameter-changefeedenabled) | bool | The blob service properties for change feed events. Indicates whether change feed event logging is enabled for the Blob service. |
| [`changeFeedRetentionInDays`](#parameter-changefeedretentionindays) | int | Indicates whether change feed event logging is enabled for the Blob service. Indicates the duration of changeFeed retention in days. A "0" value indicates an infinite retention of the change feed. |
| [`containerDeleteRetentionPolicyAllowPermanentDelete`](#parameter-containerdeleteretentionpolicyallowpermanentdelete) | bool | This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share. |
| [`containerDeleteRetentionPolicyDays`](#parameter-containerdeleteretentionpolicydays) | int | Indicates the number of days that the deleted item should be retained. |
| [`containerDeleteRetentionPolicyEnabled`](#parameter-containerdeleteretentionpolicyenabled) | bool | The blob service properties for container soft delete. Indicates whether DeleteRetentionPolicy is enabled. |
| [`containers`](#parameter-containers) | array | Blob containers to create. |
| [`corsRules`](#parameter-corsrules) | array | Specifies CORS rules for the Blob service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Blob service. |
| [`defaultServiceVersion`](#parameter-defaultserviceversion) | string | Indicates the default version to use for requests to the Blob service if an incoming request's version is not specified. Possible values include version 2008-10-27 and all more recent versions. |
| [`deleteRetentionPolicyAllowPermanentDelete`](#parameter-deleteretentionpolicyallowpermanentdelete) | bool | This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share. |
| [`deleteRetentionPolicyDays`](#parameter-deleteretentionpolicydays) | int | Indicates the number of days that the deleted blob should be retained. |
| [`deleteRetentionPolicyEnabled`](#parameter-deleteretentionpolicyenabled) | bool | The blob service properties for blob soft delete. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticLogCategoriesToEnable`](#parameter-diagnosticlogcategoriestoenable) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of a log analytics workspace. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`isVersioningEnabled`](#parameter-isversioningenabled) | bool | Use versioning to automatically maintain previous versions of your blobs. |
| [`lastAccessTimeTrackingPolicyEnabled`](#parameter-lastaccesstimetrackingpolicyenabled) | bool | The blob service property to configure last access time based tracking policy. When set to true last access time based tracking is enabled. |
| [`restorePolicyDays`](#parameter-restorepolicydays) | int | how long this blob can be restored. It should be less than DeleteRetentionPolicy days. |
| [`restorePolicyEnabled`](#parameter-restorepolicyenabled) | bool | The blob service properties for blob restore policy. If point-in-time restore is enabled, then versioning, change feed, and blob soft delete must also be enabled. |

### Parameter: `automaticSnapshotPolicyEnabled`

Automatic Snapshot is enabled if set to true.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `changeFeedEnabled`

The blob service properties for change feed events. Indicates whether change feed event logging is enabled for the Blob service.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `changeFeedRetentionInDays`

Indicates whether change feed event logging is enabled for the Blob service. Indicates the duration of changeFeed retention in days. A "0" value indicates an infinite retention of the change feed.
- Required: No
- Type: int
- Default: `7`

### Parameter: `containerDeleteRetentionPolicyAllowPermanentDelete`

This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `containerDeleteRetentionPolicyDays`

Indicates the number of days that the deleted item should be retained.
- Required: No
- Type: int
- Default: `7`

### Parameter: `containerDeleteRetentionPolicyEnabled`

The blob service properties for container soft delete. Indicates whether DeleteRetentionPolicy is enabled.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `containers`

Blob containers to create.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `corsRules`

Specifies CORS rules for the Blob service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Blob service.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `defaultServiceVersion`

Indicates the default version to use for requests to the Blob service if an incoming request's version is not specified. Possible values include version 2008-10-27 and all more recent versions.
- Required: No
- Type: string
- Default: `''`

### Parameter: `deleteRetentionPolicyAllowPermanentDelete`

This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `deleteRetentionPolicyDays`

Indicates the number of days that the deleted blob should be retained.
- Required: No
- Type: int
- Default: `7`

### Parameter: `deleteRetentionPolicyEnabled`

The blob service properties for blob soft delete.
- Required: No
- Type: bool
- Default: `True`

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
- Allowed: `['', allLogs, StorageDelete, StorageRead, StorageWrite]`

### Parameter: `diagnosticMetricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[Transaction]`
- Allowed: `[Transaction]`

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

Resource ID of a log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `isVersioningEnabled`

Use versioning to automatically maintain previous versions of your blobs.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `lastAccessTimeTrackingPolicyEnabled`

The blob service property to configure last access time based tracking policy. When set to true last access time based tracking is enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `restorePolicyDays`

how long this blob can be restored. It should be less than DeleteRetentionPolicy days.
- Required: No
- Type: int
- Default: `6`

### Parameter: `restorePolicyEnabled`

The blob service properties for blob restore policy. If point-in-time restore is enabled, then versioning, change feed, and blob soft delete must also be enabled.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `storageAccountName`

The name of the parent Storage Account. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed blob service. |
| `resourceGroupName` | string | The name of the deployed blob service. |
| `resourceId` | string | The resource ID of the deployed blob service. |

## Cross-referenced modules

_None_
