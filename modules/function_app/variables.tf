variable "environment_identifier" {
  description = "Environment identifier prefix"
  type        = string
}

variable "name" {
  description = "Name of the function app"
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

variable "sku_name" {
  description = "SKU name for App Service Plan (e.g., Y1, EP1, P1v2, S1)"
  type        = string
  default     = "Y1"
}

variable "worker_count" {
  description = "Number of workers for the App Service Plan"
  type        = number
  default     = null
}

variable "zone_balancing_enabled" {
  description = "Enable zone balancing"
  type        = bool
  default     = false
}

variable "per_site_scaling_enabled" {
  description = "Enable per-site scaling"
  type        = bool
  default     = false
}

variable "storage_account_name" {
  description = "Storage account name for function app"
  type        = string
}

variable "storage_account_access_key" {
  description = "Storage account access key"
  type        = string
  sensitive   = true
}

variable "https_only" {
  description = "Enable HTTPS only"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = false
}

variable "app_settings" {
  description = "Map of app settings"
  type        = map(string)
  default     = {}
}

variable "application_insights_key" {
  description = "Application Insights instrumentation key"
  type        = string
  default     = null
  sensitive   = true
}

variable "always_on" {
  description = "Enable always on"
  type        = bool
  default     = false
}

variable "ftps_state" {
  description = "FTPS state (AllAllowed, FtpsOnly, Disabled)"
  type        = string
  default     = "Disabled"
}

variable "http2_enabled" {
  description = "Enable HTTP/2"
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "vnet_route_all_enabled" {
  description = "Route all traffic through VNet"
  type        = bool
  default     = true
}

variable "python_version" {
  description = "Python version (3.7, 3.8, 3.9, 3.10, 3.11)"
  type        = string
  default     = "3.11"
}

variable "cors_allowed_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = null
}

variable "cors_support_credentials" {
  description = "Enable credentials support for CORS"
  type        = bool
  default     = false
}

variable "ip_restrictions" {
  description = "List of IP restriction rules"
  type = list(object({
    name                      = string
    ip_address                = optional(string)
    virtual_network_subnet_id = optional(string)
    service_tag               = optional(string)
    priority                  = number
    action                    = string
  }))
  default = []
}

variable "identity_type" {
  description = "Type of Managed Identity (SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned)"
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "List of User Assigned Identity IDs"
  type        = list(string)
  default     = []
}

variable "virtual_network_subnet_id" {
  description = "Subnet ID for VNet integration"
  type        = string
  default     = null
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
