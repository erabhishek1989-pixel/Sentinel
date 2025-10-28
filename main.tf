terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.15.0"
    }
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  min_tls_version          = var.min_tls_version
  
  enable_https_traffic_only       = var.enable_https_traffic_only
  public_network_access_enabled   = var.public_network_access_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public

  tags = var.tags
}

resource "azurerm_storage_account_network_rules" "network_rules" {
  count = var.network_rules != null ? 1 : 0

  storage_account_id = azurerm_storage_account.storage_account.id
  
  default_action             = var.network_rules.default_action
  ip_rules                   = try(var.network_rules.ip_rules, [])
  virtual_network_subnet_ids = try(var.network_rules.virtual_network_subnet_ids, [])
  bypass                     = try(var.network_rules.bypass, ["AzureServices"])
}
module "sentinel_connectors" {
  source = "./modules/sentinel_connectors"

  for_each                   = var.sentinel_connectors
  environment_identifier     = var.environment_identifier
  log_analytics_workspace_id = module.sentinel_workspace[each.value.workspace_key].log_analytics_workspace_id
  enable_mimecast            = lookup(each.value, "enable_mimecast", false)
  mimecast_config            = lookup(each.value, "mimecast_config", null)
  mimecast_polling_interval  = lookup(each.value, "mimecast_polling_interval", "PT10M")
  enable_cyberark            = lookup(each.value, "enable_cyberark", false)
  cyberark_config            = lookup(each.value, "cyberark_config", null)
  cyberark_polling_interval  = lookup(each.value, "cyberark_polling_interval", "PT10M")

  depends_on = [module.sentinel_workspace]
}