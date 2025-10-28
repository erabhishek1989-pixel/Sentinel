output "storage_account_id" {
  description = "Storage account ID"
  value       = azurerm_storage_account.storage_account.id
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.storage_account.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.storage_account.primary_blob_endpoint
}

output "primary_file_endpoint" {
  description = "Primary file endpoint"
  value       = azurerm_storage_account.storage_account.primary_file_endpoint
}

output "primary_table_endpoint" {
  description = "Primary table endpoint"
  value       = azurerm_storage_account.storage_account.primary_table_endpoint
}

output "primary_queue_endpoint" {
  description = "Primary queue endpoint"
  value       = azurerm_storage_account.storage_account.primary_queue_endpoint
}

output "primary_access_key" {
  description = "Primary access key"
  value       = azurerm_storage_account.storage_account.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "Secondary access key"
  value       = azurerm_storage_account.storage_account.secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "Primary connection string"
  value       = azurerm_storage_account.storage_account.primary_connection_string
  sensitive   = true
}

output "identity_principal_id" {
  description = "Principal ID of managed identity"
  value       = var.identity_type != null ? azurerm_storage_account.storage_account.identity[0].principal_id : null
}

output "containers" {
  description = "Created storage containers"
  value       = { for k, v in azurerm_storage_container.container : k => v.name }
}

output "file_shares" {
  description = "Created file shares"
  value       = { for k, v in azurerm_storage_share.share : k => v.name }
}

output "tables" {
  description = "Created tables"
  value       = { for k, v in azurerm_storage_table.table : k => v.name }
}

output "queues" {
  description = "Created queues"
  value       = { for k, v in azurerm_storage_queue.queue : k => v.name }
}

output "blob_private_endpoint_id" {
  description = "Blob private endpoint ID"
  value       = var.enable_blob_private_endpoint ? azurerm_private_endpoint.blob_endpoint[0].id : null
}

output "file_private_endpoint_id" {
  description = "File private endpoint ID"
  value       = var.enable_file_private_endpoint ? azurerm_private_endpoint.file_endpoint[0].id : null
}
