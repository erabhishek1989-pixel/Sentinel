
variable "sentinel_connectors" {
  description = "Sentinel connectors configuration per workspace"
  type = map(object({
    storage_account_name = optional(string)
    workspace_key = string
    connectors = map(object({
      request_config = optional(object({
        method           = string
        endpoint         = string
        headers          = map(string)
        query_parameters = map(string)
      }))
      polling_interval = optional(string, "PT10M")
      app_settings     = optional(map(string), {}) 
    }))
  }))
  default = {}
}
variable "environment_identifier" {
  description = "Environment identifier prefix (d3, t3, y3)"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "core_management_subscription_id" {
  description = "Core management subscription ID"
  type        = string
}

variable "infrastructure_client_id" {
  description = "Infrastructure client ID"
  type        = string
}

variable "sentinel_workspace" {
  description = "Sentinel workspace configuration"
  type = map(object({
    name     = string
    location = string
    sku      = string
  }))
  default = {}
}

variable "resource_groups_map" {
  description = "Map of resource groups"
  type = map(object({
    name     = string
    location = string
  }))
  default = {}
}

variable "virtual_networks_dns_servers" {
  description = "DNS servers for virtual networks"
  type        = list(string)
  default     = []
}

variable "azure_virtual_desktop" {
  description = "Azure Virtual Desktop configuration"
  type        = any
  default     = {}
}
variable "function_apps" {
  description = "Map of Function Apps configuration"
  type = map(object({
    name                          = string
    location                      = string
    sku_name                      = string
    storage_account_key           = string
    python_version                = string
    https_only                    = bool
    public_network_access_enabled = bool
    always_on                     = bool
    app_settings                  = map(string)
    ftps_state                    = string
    http2_enabled                 = bool
    minimum_tls_version           = string
    vnet_route_all_enabled        = bool
    identity_type                 = string
    enable_private_endpoint       = bool
  }))
  default = {}
}

variable "storage_accounts" {
  description = "Map of Storage Accounts configuration"
  type = map(object({
    name                            = string
    location                        = string
    account_tier                    = string
    account_replication_type        = string
    account_kind                    = string
    access_tier                     = string
    https_traffic_only_enabled      = bool
    min_tls_version                 = string
    allow_nested_items_to_be_public = bool
    shared_access_key_enabled       = bool
    public_network_access_enabled   = bool
    network_rules = optional(object({
      default_action             = string
      bypass                     = list(string)
      ip_rules                   = list(string)
      virtual_network_subnet_ids = list(string)
    }))
    blob_properties = optional(object({
      versioning_enabled              = bool
      change_feed_enabled             = bool
      last_access_time_enabled        = bool
      delete_retention_days           = number
      container_delete_retention_days = number
    }))
    identity_type = string
    containers = map(object({
      name                  = string
      container_access_type = string
    }))
    file_shares = map(object({
      name             = string
      quota            = number
      enabled_protocol = string
      access_tier      = string
    }))
    tables = map(object({
      name = string
    }))
    queues = map(object({
      name = string
    }))
    enable_blob_private_endpoint  = bool
    enable_file_private_endpoint  = optional(bool, false)
    enable_table_private_endpoint = optional(bool, false)
    enable_queue_private_endpoint = optional(bool, false)
  }))
  default = {}
}
variable "virtual_networks" {
  description = "Map of virtual networks configuration"
  type        = any
  default     = {}
}