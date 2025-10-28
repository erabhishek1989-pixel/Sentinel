output "service_plan_id" {
  description = "App Service Plan ID"
  value       = azurerm_service_plan.service_plan.id
}

output "service_plan_name" {
  description = "App Service Plan name"
  value       = azurerm_service_plan.service_plan.name
}

output "function_app_id" {
  description = "Function App ID"
  value       = azurerm_linux_function_app.function_app.id
}

output "function_app_name" {
  description = "Function App name"
  value       = azurerm_linux_function_app.function_app.name
}

output "function_app_default_hostname" {
  description = "Function App default hostname"
  value       = azurerm_linux_function_app.function_app.default_hostname
}

output "function_app_identity_principal_id" {
  description = "Function App managed identity principal ID"
  value       = azurerm_linux_function_app.function_app.identity[0].principal_id
}

output "function_app_identity_tenant_id" {
  description = "Function App managed identity tenant ID"
  value       = azurerm_linux_function_app.function_app.identity[0].tenant_id
}

output "function_app_outbound_ip_addresses" {
  description = "Function App outbound IP addresses"
  value       = azurerm_linux_function_app.function_app.outbound_ip_addresses
}

output "function_app_possible_outbound_ip_addresses" {
  description = "Function App possible outbound IP addresses"
  value       = azurerm_linux_function_app.function_app.possible_outbound_ip_addresses
}

output "private_endpoint_id" {
  description = "Private endpoint ID"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.function_app_endpoint[0].id : null
}

output "private_endpoint_ip_address" {
  description = "Private endpoint private IP address"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.function_app_endpoint[0].private_service_connection[0].private_ip_address : null
}
