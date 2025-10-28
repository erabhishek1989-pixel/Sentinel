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