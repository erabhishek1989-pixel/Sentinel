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

output "function_apps" {
  description = "Function Apps created for connectors"
  value = {
    for k, v in module.connector_function_apps : k => {
      id                    = v.function_app_id
      name                  = v.function_app_name
      default_hostname      = v.function_app_default_hostname
      identity_principal_id = v.function_app_identity_principal_id
    }
  }
}

output "storage_accounts" {
  description = "Storage Accounts created for function apps"
  value = {
    for k, v in module.connector_storage_accounts : k => {
      id   = v.storage_account_id
      name = v.storage_account_name
    }
  }
}
