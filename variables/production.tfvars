environment                     = "Production"
environment_identifier          = "y3"
subscription_id                 = "9d569d3f-4846-43ac-94ad-19ac3c8676a9"
tenant_id                       = "fb973a23-5188-45ab-b4fb-277919443584"
core_management_subscription_id = "2bdf8cf8-7375-4406-96af-ececefba1dbe"

infrastructure_client_id = "cf42de7e-6179-43f5-8e16-84c2e3665ea8"


### NETWORKING ###

virtual_networks_dns_servers = ["10.0.0.116", "172.21.112.10"]

virtual_networks = {
  "vnet-core-security-uksouth-0001" = {
    name          = "y3-vnet-core-security-uksouth-0001"
    location      = "UK South"
    address_space = ["10.0.60.0/24"]
    peerings = {
      "core-security-uksouth-to-core-uksouth" = {
        name        = "peer_prod_vnet_core_security_uksouth_to_y3_core_networking_uksouth"
        remote_peer = false
      },
      "core-uksouth-to-core-security-uksouth" = {
        name        = "peer_y3_core_networking_uksouth_to_prod_vnet_core_security_uksouth"
        remote_peer = true
      }
    }
    subnets = {
      "snet-core-security-uksouth-avd" = {
        name             = "y3-snet-core-security-uksouth-avd"
        address_prefixes = ["10.0.60.0/27"]
      }
      "snet-core-security-uksouth-storage" = {
        name             = "y3-snet-core-security-uksouth-storage"
        address_prefixes = ["10.0.60.32/28"]
      }
      "snet-core-security-uksouth-functionapp" = {
        name             = "y3-snet-core-security-uksouth-functionapp"
        address_prefixes = ["10.0.60.48/28"]
        delegation       = ["Microsoft.Web/serverFarms"]
      }
    }
    route_tables = {
      "route-core-security" = {
        name = "y3-route-core-security-uksouth-0001"
        routes = {
          "default" = {
            name                   = "default"
            address_prefix         = "0.0.0.0/0"
            next_hop_type          = "VirtualAppliance"
            next_hop_in_ip_address = "10.0.0.4"
          }
        }
      }
    }
  },
  "vnet-core-security-ukwest-0001" = {
    name          = "y3-vnet-core-security-ukwest-0001"
    location      = "UK West"
    address_space = ["10.2.60.0/24"]
    peerings = {
      "core-security-ukwest-to-core-ukwest" = {
        name        = "peer_prod_vnet_core_security_ukwest_to_y3_core_networking_ukwest"
        remote_peer = false
      },
      "core-ukwest-to-core-security-ukwest" = {
        name        = "peer_y3_core_networking_ukwest_to_prod_core_security_ukwest"
        remote_peer = true
      }
    }
    subnets = {
      "snet-core-security-ukwest-avd" = {
        name             = "y3-snet-core-security-ukwest-avd"
        address_prefixes = ["10.2.60.0/27"]
      }
      "snet-core-security-ukwest-storage" = {
        name             = "y3-snet-core-security-ukwest-storage"
        address_prefixes = ["10.2.60.32/28"]
      }
      "snet-core-security-ukwest-functionapp" = {
        name             = "y3-snet-core-security-ukwest-functionapp"
        address_prefixes = ["10.2.60.48/28"]
        delegation       = ["Microsoft.Web/serverFarms"]
      }
    }
    route_tables = {
      "route-core-security" = {
        name = "y3-route-core-security-ukwest-0001"
        routes = {
          "default" = {
            name                   = "default"
            address_prefix         = "0.0.0.0/0"
            next_hop_type          = "VirtualAppliance"
            next_hop_in_ip_address = "10.0.0.4"
          }
        }
      }
    }
  }
}

sentinel_connectors = {
  "connectors-uksouth" = {
    workspace_key = "log-core-security-sentinel-uksouth-0001"
    connectors = {
      "mimecast" = {
        polling_interval = "PT10M"
        request_config = {
          method           = "GET"
          endpoint         = "https://api.mimecast.com/your-endpoint"
          headers          = { "Authorization" = "Bearer YOUR_TOKEN" }
          query_parameters = {}
        }
      }
      "cyberark" = {
        polling_interval = "PT10M"
        request_config = {
          method           = "GET"
          endpoint         = "https://your-cyberark-endpoint.com/api"
          headers          = { "Authorization" = "Bearer YOUR_TOKEN" }
          query_parameters = {}
        }
      }
      ##Need to add code to ensure Azure AD is connected
    }
  }
}
### STORAGE ACCOUNTS ###

storage_accounts = {
  "st-core-security-uksouth-func" = {
    name                     = "y3stcoresecfuncuks001"  # Must be globally unique, 3-24 lowercase alphanumeric
    location                 = "UK South"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    access_tier              = "Hot"
    
    # Security Settings
    enable_https_traffic_only       = true
    min_tls_version                 = "TLS1_2"
    allow_nested_items_to_be_public = false
    shared_access_key_enabled       = true
    public_network_access_enabled   = false
    
    # Network Rules
    network_rules = {
      default_action             = "Deny"
      bypass                     = ["AzureServices"]
      ip_rules                   = []
      virtual_network_subnet_ids = []
    }
    
    # Blob Properties
    blob_properties = {
      versioning_enabled              = true
      change_feed_enabled             = true
      last_access_time_enabled        = true
      delete_retention_days           = 7
      container_delete_retention_days = 7
    }
    
    # Managed Identity
    identity_type = "SystemAssigned"
    
    # Containers
    containers = {
      "function-deployments" = {
        name                  = "function-deployments"
        container_access_type = "private"
      }
    }
    
    # File Shares
    file_shares = {}
    
    # Tables
    tables = {}
    
    # Queues
    queues = {}
    
    # Private Endpoints
    enable_blob_private_endpoint = true
    enable_file_private_endpoint = false
    enable_table_private_endpoint = false
    enable_queue_private_endpoint = false
    # Note: private_endpoint_subnet_id will be dynamically set in main.tf using module reference
  }
  
  "st-core-security-ukwest-func" = {
    name                     = "y3stcoresecfuncukw001"  # Must be globally unique, 3-24 lowercase alphanumeric
    location                 = "UK West"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    access_tier              = "Hot"
    
    # Security Settings
    enable_https_traffic_only       = true
    min_tls_version                 = "TLS1_2"
    allow_nested_items_to_be_public = false
    shared_access_key_enabled       = true
    public_network_access_enabled   = false
    
    # Network Rules
    network_rules = {
      default_action             = "Deny"
      bypass                     = ["AzureServices"]
      ip_rules                   = []
      virtual_network_subnet_ids = []
    }
    
    # Blob Properties
    blob_properties = {
      versioning_enabled              = true
      change_feed_enabled             = true
      last_access_time_enabled        = true
      delete_retention_days           = 7
      container_delete_retention_days = 7
    }
    
    # Managed Identity
    identity_type = "SystemAssigned"
    
    # Containers
    containers = {
      "function-deployments" = {
        name                  = "function-deployments"
        container_access_type = "private"
      }
    }
    
    # File Shares
    file_shares = {}
    
    # Tables
    tables = {}
    
    # Queues
    queues = {}
    
    # Private Endpoints
    enable_blob_private_endpoint = true
    enable_file_private_endpoint = false
    enable_table_private_endpoint = false
    enable_queue_private_endpoint = false
  }
}

### FUNCTION APPS ###

function_apps = {
  "func-core-security-uksouth" = {
    name                = "core-security-uksouth"
    location            = "UK South"
    sku_name            = "EP1" # Elastic Premium for VNet integration
    storage_account_key = "st-core-security-uksouth-func"
    python_version      = "3.11"
    
    # Configuration
    https_only                    = true
    public_network_access_enabled = false
    always_on                     = true
    
    # App Settings
    app_settings = {
      "FUNCTIONS_EXTENSION_VERSION" = "~4"
      "WEBSITE_CONTENTOVERVNET"     = "1"
      "AzureWebJobsFeatureFlags"    = "EnableWorkerIndexing"
    }
    
    # Security
    ftps_state          = "Disabled"
    http2_enabled       = true
    minimum_tls_version = "1.2"
    
    # VNet Integration
    vnet_route_all_enabled = true
    # Note: virtual_network_subnet_id will be set dynamically in main.tf using module reference
    
    # Managed Identity
    identity_type = "SystemAssigned"
    
    # Private Endpoint
    enable_private_endpoint = true
    # Note: private_endpoint_subnet_id will be set dynamically in main.tf using module reference
  }
  
  "func-core-security-ukwest" = {
    name                = "core-security-ukwest"
    location            = "UK West"
    sku_name            = "EP1" # Elastic Premium for VNet integration
    storage_account_key = "st-core-security-ukwest-func"
    python_version      = "3.11"
    
    # Configuration
    https_only                    = true
    public_network_access_enabled = false
    always_on                     = true
    
    # App Settings
    app_settings = {
      "FUNCTIONS_EXTENSION_VERSION" = "~4"
      "WEBSITE_CONTENTOVERVNET"     = "1"
      "AzureWebJobsFeatureFlags"    = "EnableWorkerIndexing"
    }
    
    # Security
    ftps_state          = "Disabled"
    http2_enabled       = true
    minimum_tls_version = "1.2"
    
    # VNet Integration
    vnet_route_all_enabled = true
    # Note: virtual_network_subnet_id will be set dynamically in main.tf using module reference
    
    # Managed Identity
    identity_type = "SystemAssigned"
    
    # Private Endpoint
    enable_private_endpoint = true
    # Note: private_endpoint_subnet_id will be set dynamically in main.tf using module reference
  }
}
