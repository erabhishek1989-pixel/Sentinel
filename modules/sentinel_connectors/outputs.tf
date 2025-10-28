output "mimecast_connector_id" {
  value = var.enable_mimecast ? azurerm_sentinel_data_connector_api_polling.mimecast[0].id : null
}

output "cyberark_connector_id" {
  value = var.enable_cyberark ? azurerm_sentinel_data_connector_api_polling.cyberark[0].id : null
}