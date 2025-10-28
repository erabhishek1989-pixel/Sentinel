resource "azurerm_sentinel_data_connector_api_polling" "connector" {
  for_each = var.connectors
  
  name                       = "${var.environment_identifier}-sentinel-connector-${each.key}"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "request" {
    for_each = each.value.request_config != null ? [each.value.request_config] : []
    content {
      method           = request.value.method
      endpoint         = request.value.endpoint
      headers          = request.value.headers
      query_parameters = request.value.query_parameters
    }
  }

  polling_interval = each.value.polling_interval
}