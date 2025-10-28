variable "environment_identifier" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "connectors" {
  description = "Map of Sentinel connectors configuration"
  type = map(object({
    request_config = optional(object({
      method           = string
      endpoint         = string
      headers          = map(string)
      query_parameters = map(string)
    }))
    polling_interval = optional(string, "PT10M")
  }))
  default = {}
}