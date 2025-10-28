variable "name" {
  description = "Name of the workspace"
  type        = string
}

variable "environment_identifier" {
  description = "Environment identifier prefix"
  type        = string
}

variable "location" {
  description = "Azure region location"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku" {
  description = "SKU of the Log Analytics Workspace"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

variable "workspace_shared_key_secret_uri" {
  description = "Key Vault secret URI for workspace shared key"
  type        = string
  default     = null
}

variable "application_insights_key" {
  description = "Application Insights instrumentation key"
  type        = string
  default     = null
}

variable "connectors" {
  description = "Map of Sentinel data connectors configuration"
  type = map(object({
    enabled                  = bool
    connector_type           = string
    key_vault_name           = optional(string)
    key_vault_resource_group = optional(string)
    endpoint                 = optional(string)
    secrets                  = optional(map(string))
    config                   = optional(map(any))
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
variable "connectors" {
  description = "Map of connectors to create function apps for"
  type = map(object({
    enabled      = bool
    app_settings = optional(map(string), {})
  }))
  default = {}
}