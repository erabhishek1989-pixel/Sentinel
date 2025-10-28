output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

output "log_analytics_workspace" {
  description = "Full Log Analytics Workspace object"
  value       = azurerm_log_analytics_workspace.log_analytics_workspace
}

output "workspace_id" {
  description = "Workspace ID (GUID)"
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
}


