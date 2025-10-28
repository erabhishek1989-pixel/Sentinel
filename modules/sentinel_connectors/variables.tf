variable "environment_identifier" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "enable_mimecast" {
  type    = bool
  default = false
}

variable "mimecast_config" {
  type = object({
    endpoint         = string
    headers          = map(string)
    query_parameters = map(string)
  })
  default = null
}

variable "mimecast_polling_interval" {
  type    = string
  default = "PT10M"
}

variable "enable_cyberark" {
  type    = bool
  default = false
}

variable "cyberark_config" {
  type = object({
    endpoint         = string
    headers          = map(string)
    query_parameters = map(string)
  })
  default = null
}

variable "cyberark_polling_interval" {
  type    = string
  default = "PT10M"
}