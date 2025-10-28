
variable "sentinel_connectors" {
  description = "Sentinel connectors configuration per workspace"
  type = map(object({
    workspace_key = string
    connectors = map(object({
      request_config = optional(object({
        method           = string
        endpoint         = string
        headers          = map(string)
        query_parameters = map(string)
      }))
      polling_interval = optional(string, "PT10M")
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
  type        = any
  default     = {}
}
variable "virtual_networks" {
  description = "Map of virtual networks configuration"
  type        = any
  default     = {}
}