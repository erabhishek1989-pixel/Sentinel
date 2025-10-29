output "connector_summary" {
  description = "Summary of configured connectors"
  value = {
    workspace_id = var.log_analytics_workspace_id
    connectors   = [for k, v in var.connectors : k]
  }
}