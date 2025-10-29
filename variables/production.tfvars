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
  "log-core-security-sentinel-uksouth-0001" = {
    workspace_key = "log-core-security-sentinel-uksouth-0001"
    connectors = {
      "cyberark" = {
        app_settings = {
          # CyberArk SaaS API endpoints
          "CYBERARK_API_ENDPOINT"      = "https://your-tenant.cyberark.cloud/api/v1"
          "CYBERARK_API_KEY"           = "@Microsoft.KeyVault(SecretUri=https://y3-kv-coremgt-uks-0001.vault.azure.net/secrets/cyberark-api-key/)"
          "CYBERARK_TENANT_ID"         = "your-cyberark-tenant-id"  # to be updated
          "LOG_TYPE"                   = "CyberArk_CL"
          "POLLING_INTERVAL_MINUTES"   = "10"
        }
        polling_interval = "PT10M"
      }
      "mimecast" = {
        app_settings = {
          # Mimecast SaaS API configuration
          "MIMECAST_BASE_URL"          = "https://eu-api.mimecast.com"  # to be updated
          "MIMECAST_APP_ID"            = "your-mimecast-app-id"  # to be updated
          "MIMECAST_APP_KEY"           = "@Microsoft.KeyVault(SecretUri=https://y3-kv-coremgt-uks-0001.vault.azure.net/secrets/mimecast-app-key/)"
          "MIMECAST_ACCESS_KEY"        = "@Microsoft.KeyVault(SecretUri=https://y3-kv-coremgt-uks-0001.vault.azure.net/secrets/mimecast-access-key/)"
          "MIMECAST_SECRET_KEY"        = "@Microsoft.KeyVault(SecretUri=https://y3-kv-coremgt-uks-0001.vault.azure.net/secrets/mimecast-secret-key/)"
          "LOG_TYPE"                   = "Mimecast_CL"
          "POLLING_INTERVAL_MINUTES"   = "10"
        }
        polling_interval = "PT10M"
      }
      
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
    https_traffic_only_enabled      = true
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
    https_traffic_only_enabled      = true
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
    sku_name            = "Y1"  
    storage_account_key = "st-core-security-uksouth-func"
    python_version      = "3.11"
    
    https_only                    = true
    public_network_access_enabled = true  # Changed - SaaS APIs need public access
    always_on                     = false  # Consumption plan doesn't support always_on
    
    app_settings = {
      "FUNCTIONS_EXTENSION_VERSION" = "~4"
    }
    
    ftps_state          = "Disabled"
    http2_enabled       = true
    minimum_tls_version = "1.2"
    
    vnet_route_all_enabled = false  # Not needed for SaaS
    identity_type          = "SystemAssigned"
    enable_private_endpoint = false  # Not needed for SaaS
  }
}
