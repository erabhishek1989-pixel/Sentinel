output "sentinel_connectors_summary" {
  description = "Summary of configured Sentinel connectors"
  value = {
    for workspace_key, workspace_config in var.sentinel_connectors : workspace_key => {
      workspace_id = module.sentinel_workspace[workspace_config.workspace_key].log_analytics_workspace_id
      connectors   = keys(workspace_config.connectors)
      function_apps = [
        for connector_key in keys(workspace_config.connectors) : 
        "y3-func-sentinel-${connector_key}"
      ]
    }
  }
}
