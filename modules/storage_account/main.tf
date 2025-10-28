# Storage Account Module
# Creates Azure Storage Accounts with containers, file shares, and network rules

resource "azurerm_storage_account" "storage_account" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  access_tier              = var.access_tier
  https_traffic_only_enabled      = var.enable_https_traffic_only
  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  
  # Network Rules
  public_network_access_enabled = var.public_network_access_enabled
  
  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  # Blob Properties
  dynamic "blob_properties" {
    for_each = var.blob_properties != null ? [var.blob_properties] : []
    content {
      versioning_enabled       = blob_properties.value.versioning_enabled
      change_feed_enabled      = blob_properties.value.change_feed_enabled
      last_access_time_enabled = blob_properties.value.last_access_time_enabled

      dynamic "delete_retention_policy" {
        for_each = blob_properties.value.delete_retention_days != null ? [1] : []
        content {
          days = blob_properties.value.delete_retention_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = blob_properties.value.container_delete_retention_days != null ? [1] : []
        content {
          days = blob_properties.value.container_delete_retention_days
        }
      }
    }
  }

  # Identity
  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.identity_ids : null
    }
  }

  tags = var.tags
}

# Storage Containers
resource "azurerm_storage_container" "container" {
  for_each              = var.containers
  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = each.value.container_access_type

  depends_on = [azurerm_storage_account.storage_account]
}

# Storage File Shares
resource "azurerm_storage_share" "share" {
  for_each             = var.file_shares
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = each.value.quota
  enabled_protocol     = each.value.enabled_protocol
  access_tier          = each.value.access_tier

  depends_on = [azurerm_storage_account.storage_account]
}

# Storage Tables
resource "azurerm_storage_table" "table" {
  for_each             = var.tables
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage_account.name

  depends_on = [azurerm_storage_account.storage_account]
}

# Storage Queues
resource "azurerm_storage_queue" "queue" {
  for_each             = var.queues
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage_account.name

  depends_on = [azurerm_storage_account.storage_account]
}

# Private Endpoint for Blob
resource "azurerm_private_endpoint" "blob_endpoint" {
  count               = var.enable_blob_private_endpoint ? 1 : 0
  name                = "${var.name}-pe-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.name}-psc-blob"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags

  depends_on = [azurerm_storage_account.storage_account]
}

# Private Endpoint for File
resource "azurerm_private_endpoint" "file_endpoint" {
  count               = var.enable_file_private_endpoint ? 1 : 0
  name                = "${var.name}-pe-file"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.name}-psc-file"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  tags = var.tags

  depends_on = [azurerm_storage_account.storage_account]
}

# Private Endpoint for Table
resource "azurerm_private_endpoint" "table_endpoint" {
  count               = var.enable_table_private_endpoint ? 1 : 0
  name                = "${var.name}-pe-table"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.name}-psc-table"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  tags = var.tags

  depends_on = [azurerm_storage_account.storage_account]
}

# Private Endpoint for Queue
resource "azurerm_private_endpoint" "queue_endpoint" {
  count               = var.enable_queue_private_endpoint ? 1 : 0
  name                = "${var.name}-pe-queue"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.name}-psc-queue"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  tags = var.tags

  depends_on = [azurerm_storage_account.storage_account]
}
