resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${var.environment_identifier}-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  daily_quota_gb      = -1

  tags = var.tags
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel_log_analytics_workspace_onboarding" {
  workspace_id                 = azurerm_log_analytics_workspace.log_analytics_workspace.id
  customer_managed_key_enabled = false

  depends_on = [azurerm_log_analytics_workspace.log_analytics_workspace]
}

resource "azurerm_user_assigned_identity" "sentinel_log_analyics_managed_identity" {
  name                = "${var.environment_identifier}-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}
# Storage Accounts for Connector Function Apps
module "connector_storage_accounts" {
  source   = "../storage_account"
  for_each = var.connectors

  name                            = "${var.environment_identifier}stsentcon${substr(each.key, 0, 8)}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  access_tier                     = "Hot"
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
  public_network_access_enabled   = false
  
  identity_type = "SystemAssigned"
  containers    = {}
  file_shares   = {}
  tables        = {}
  queues        = {}
  
  enable_blob_private_endpoint = false
  
  tags = var.tags
}

# Function Apps for Connectors
module "connector_function_apps" {
  source   = "../function_app"
  for_each = var.connectors

  environment_identifier        = var.environment_identifier
  name                          = "sentinel-${each.key}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku_name                      = "Y1" # Consumption plan
  storage_account_name          = module.connector_storage_accounts[each.key].storage_account_name
  storage_account_access_key    = module.connector_storage_accounts[each.key].primary_access_key
  python_version                = "3.11"
  
  https_only                    = true
  public_network_access_enabled = true
  always_on                     = false
  
  app_settings = merge(
    {
      "FUNCTIONS_EXTENSION_VERSION" = "~4"
      "WORKSPACE_ID"                = azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
      "WORKSPACE_KEY"               = azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
    },
    lookup(each.value, "app_settings", {})
  )
  
  ftps_state                = "Disabled"
  http2_enabled             = true
  minimum_tls_version       = "1.2"
  vnet_route_all_enabled    = false
  virtual_network_subnet_id = null
  identity_type             = "SystemAssigned"
  enable_private_endpoint   = false
  
  tags = var.tags
  
  depends_on = [module.connector_storage_accounts]
}
