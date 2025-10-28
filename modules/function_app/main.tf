# Function App Module - Linux with Python Runtime
# Creates Azure Function Apps with App Service Plans and VNet integration

# App Service Plan (Linux)
resource "azurerm_service_plan" "service_plan" {
  name                = "${var.environment_identifier}-asp-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  
  worker_count                 = var.worker_count
  zone_balancing_enabled       = var.zone_balancing_enabled
  per_site_scaling_enabled     = var.per_site_scaling_enabled

  tags = var.tags
}

# Linux Function App with Python Runtime
resource "azurerm_linux_function_app" "function_app" {
  name                       = "${var.environment_identifier}-func-${var.name}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.service_plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  
  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.virtual_network_subnet_id
  
  # App Settings
  app_settings = merge(
    var.app_settings,
    {
      "FUNCTIONS_WORKER_RUNTIME"       = "python"
      "WEBSITE_RUN_FROM_PACKAGE"       = "1"
      "APPINSIGHTS_INSTRUMENTATIONKEY" = var.application_insights_key != null ? var.application_insights_key : ""
    }
  )

  site_config {
    always_on                  = var.always_on
    ftps_state                 = var.ftps_state
    http2_enabled              = var.http2_enabled
    minimum_tls_version        = var.minimum_tls_version
    vnet_route_all_enabled     = var.vnet_route_all_enabled
    
    # Python Application Stack
    application_stack {
      python_version = var.python_version
    }

    dynamic "cors" {
      for_each = var.cors_allowed_origins != null ? [1] : []
      content {
        allowed_origins     = var.cors_allowed_origins
        support_credentials = var.cors_support_credentials
      }
    }

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions
      content {
        name                      = ip_restriction.value.name
        ip_address                = ip_restriction.value.ip_address
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
        service_tag               = ip_restriction.value.service_tag
        priority                  = ip_restriction.value.priority
        action                    = ip_restriction.value.action
      }
    }
  }

  # Managed Identity
  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.identity_ids : null
  }

  tags = var.tags

  depends_on = [azurerm_service_plan.service_plan]
}
# Private Endpoint for Function App
resource "azurerm_private_endpoint" "function_app_endpoint" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.environment_identifier}-pe-func-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.environment_identifier}-psc-func-${var.name}"
    private_connection_resource_id = azurerm_linux_function_app.function_app.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  tags = var.tags

  depends_on = [azurerm_linux_function_app.function_app]
}
