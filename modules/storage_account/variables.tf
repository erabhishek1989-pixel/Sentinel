variable "name" {
  description = "Name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region location"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage account replication type (LRS, GRS, RAGRS, ZRS, etc.)"
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "Storage account kind (Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage)"
  type        = string
  default     = "StorageV2"
}

variable "access_tier" {
  description = "Access tier for BlobStorage, FileStorage and StorageV2 accounts (Hot or Cool)"
  type        = string
  default     = "Hot"
}

variable "enable_https_traffic_only" {
  description = "Enable HTTPS traffic only"
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "allow_nested_items_to_be_public" {
  description = "Allow nested items to be public"
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Enable shared access key"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = false
}

variable "network_rules" {
  description = "Network rules for storage account"
  type = object({
    default_action             = string
    bypass                     = list(string)
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "blob_properties" {
  description = "Blob properties configuration"
  type = object({
    versioning_enabled               = bool
    change_feed_enabled              = bool
    last_access_time_enabled         = bool
    delete_retention_days            = number
    container_delete_retention_days  = number
  })
  default = null
}

variable "identity_type" {
  description = "Type of Managed Identity (SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned)"
  type        = string
  default     = null
}

variable "identity_ids" {
  description = "List of User Assigned Identity IDs"
  type        = list(string)
  default     = []
}

variable "containers" {
  description = "Map of storage containers to create"
  type = map(object({
    name                  = string
    container_access_type = string
  }))
  default = {}
}

variable "file_shares" {
  description = "Map of file shares to create"
  type = map(object({
    name             = string
    quota            = number
    enabled_protocol = string
    access_tier      = string
  }))
  default = {}
}

variable "tables" {
  description = "Map of tables to create"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "queues" {
  description = "Map of queues to create"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "enable_blob_private_endpoint" {
  description = "Enable private endpoint for blob"
  type        = bool
  default     = false
}

variable "enable_file_private_endpoint" {
  description = "Enable private endpoint for file"
  type        = bool
  default     = false
}

variable "enable_table_private_endpoint" {
  description = "Enable private endpoint for table"
  type        = bool
  default     = false
}

variable "enable_queue_private_endpoint" {
  description = "Enable private endpoint for queue"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoints"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
