# Mimecast Connector
resource "azurerm_sentinel_data_connector_api_polling" "mimecast" {
  count                      = var.enable_mimecast ? 1 : 0
  name                       = "${var.environment_identifier}-sentinel-connector-mimecast"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "request" {
    for_each = var.mimecast_config != null ? [var.mimecast_config] : []
    content {
      method           = "GET"
      endpoint         = request.value.endpoint
      headers          = request.value.headers
      query_parameters = request.value.query_parameters
    }
  }

  polling_interval = var.mimecast_polling_interval
}

# CyberArk Connector
resource "azurerm_sentinel_data_connector_api_polling" "cyberark" {
  count                      = var.enable_cyberark ? 1 : 0
  name                       = "${var.environment_identifier}-sentinel-connector-cyberark"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "request" {
    for_each = var.cyberark_config != null ? [var.cyberark_config] : []
    content {
      method           = "GET"
      endpoint         = request.value.endpoint
      headers          = request.value.headers
      query_parameters = request.value.query_parameters
    }
  }

  polling_interval = var.cyberark_polling_interval
}