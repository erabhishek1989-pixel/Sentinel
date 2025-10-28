output "connector_ids" {
  description = "Map of connector IDs"
  value       = { for k, v in azurerm_sentinel_data_connector_api_polling.connector : k => v.id }
}

output "connector_names" {
  description = "Map of connector names"
  value       = { for k, v in azurerm_sentinel_data_connector_api_polling.connector : k => v.name }
}