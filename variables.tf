variable "name" {
  description = "Name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region location"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "Storage account kind"
  type        = string
  default     = "StorageV2"
}

variable "min_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "enable_https_traffic_only" {
  description = "Enable HTTPS traffic only"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "allow_nested_items_to_be_public" {
  description = "Allow nested items to be public"
  type        = bool
  default     = false
}

variable "network_rules" {
  description = "Network rules for storage account"
  type = object({
    default_action             = string
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
    bypass                     = optional(list(string))
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
variable "sentinel_connectors" {
  type = map(object({
    workspace_key             = string
    enable_mimecast           = optional(bool, false)
    enable_cyberark           = optional(bool, false)
    mimecast_config           = optional(object({
      endpoint         = string
      headers          = map(string)
      query_parameters = map(string)
    }))
    mimecast_polling_interval = optional(string, "PT10M")
    cyberark_config           = optional(object({
      endpoint         = string
      headers          = map(string)
      query_parameters = map(string)
    }))
    cyberark_polling_interval = optional(string, "PT10M")
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
  type        = any
  default     = {}
}
variable "virtual_networks" {
  description = "Map of virtual networks configuration"
  type        = any
  default     = {}
}