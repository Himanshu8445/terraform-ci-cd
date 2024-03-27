## RESOURCE GROUPS
resource_groups = {
  rg_net = {
    name     = "rg-udf-dl-net-sx-eus2-01"
    location = "East US 2"
    tags = {
      iac = "Terraform"
    }
  },
  rg_runtime = {
    name     = "rg-udf-dl-runtime-sx-eus2-01"
    location = "East US 2"
    tags = {
      iac = "Terraform"
    }
  },
  rg_storage = {
    name     = "rg-udf-dl-storage-sx-eus2-01"
    location = "East US 2"
    tags = {
      iac = "Terraform"
    }
  },
  rg_integration = {
    name     = "rg-udf-dl-integration-sx-eus2-01"
    location = "East US 2"
    tags = {
      iac = "Terraform"
    }
  },
  rg_ascend = {
    name     = "rg-udf-dl-ascend-sx-eus2-01"
    location = "East US 2"
    tags = {
      iac = "Terraform"
    }
  }
}

## STORAGE ACCOUNTS
storage_accounts = {
  str_acct_1 = {
    name                            = "studfsxeus201bronze"
    sku                             = "Standard_LRS"
    resource_group_name             = "rg-udf-dl-storage-sx-eus2-01"
    location                        = "East US 2"
    account_kind                    = null
    access_tier                     = null
    assign_identity                 = true
    cmk_enable                      = true
    min_tls_version                 = "TLS1_2"
    is_hns_enabled                  = "true"
    large_file_share_enabled        = true
    network_rules                   = null
    public_network_access_enabled   = "true"
    allow_nested_items_to_be_public = "true"
  },
  str_acct_2 = {
    name                            = "studfsxeus201silver"
    sku                             = "Standard_LRS"
    resource_group_name             = "rg-udf-dl-storage-sx-eus2-01"
    location                        = "East US 2"
    account_kind                    = null
    access_tier                     = null
    assign_identity                 = true
    cmk_enable                      = true
    min_tls_version                 = "TLS1_2"
    is_hns_enabled                  = "true"
    large_file_share_enabled        = true
    network_rules                   = null
    public_network_access_enabled   = "true"
    allow_nested_items_to_be_public = "true"
  },
  str_acct_3 = {
    name                            = "studfsxeus201gold"
    sku                             = "Standard_LRS"
    resource_group_name             = "rg-udf-dl-storage-sx-eus2-01"
    location                        = "East US 2"
    account_kind                    = null
    access_tier                     = null
    assign_identity                 = true
    cmk_enable                      = true
    min_tls_version                 = "TLS1_2"
    is_hns_enabled                  = "true"
    large_file_share_enabled        = true
    network_rules                   = null
    public_network_access_enabled   = "true"
    allow_nested_items_to_be_public = "true"
  }
}

containers = {}

sa_additional_tags = {
  iac = "Terraform"
}

### Virtual Network

resource_group_name_network = "rg-udf-dl-net-sx-eus2-01"

virtual_networks = {
  vnet_1 = {
    name                 = "vnet-udf-dl-sx-eus2-01"
    location             = "East US 2"
    address_space        = ["10.11.0.0/16"]
    dns_servers          = null
    ddos_protection_plan = null
  }
}

subnets = {
  subnet1 = {
    vnet_key          = "vnet_1"
    vnet_name         = "vnet-udf-dl-sx-eus2-01"
    name              = "snet-udf-dl-misc-eus2-01"
    address_prefixes  = ["10.11.0.0/24"]
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    pe_enable         = false
    delegation        = null
  },
  subnet2 = {
    vnet_key          = "vnet_1"
    vnet_name         = "vnet-udf-dl-sx-eus2-01"
    name              = "snet-udf-dl-dbx-pub-eus2-01"
    address_prefixes  = ["10.11.1.0/24"]
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.AzureActiveDirectory"]
    pe_enable         = false
    delegation = [
      {
        name = "dbxpublicdelegation"
        service_delegation = [
          {
            name    = "Microsoft.Databricks/workspaces"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
          }
        ]
      }
    ]
  },
  subnet3 = {
    vnet_key          = "vnet_1"
    vnet_name         = "vnet-udf-dl-sx-eus2-01"
    name              = "snet-udf-dl-dbx-pri-eus2-01"
    address_prefixes  = ["10.11.2.0/24"]
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql"]
    pe_enable         = false
    delegation = [
      {
        name = "dbxprivatedelegation"
        service_delegation = [
          {
            name    = "Microsoft.Databricks/workspaces"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
          }
        ]
      }
    ]
  }
}

vnet_tags = {
  iac = "Terraform"
}

## Network Security Group

network_security_groups = {
  nsg1 = {
    name                = "nsg-udf-dl-test-eus2-01"
    location            = "East US 2"
    resource_group_name = "rg-udf-dl-net-sx-eus2-01"
    security_rules      = []
  }
}

nsg_subnet_association = {
  nsg_subnet_association_1 = {
    nsg_name  = "nsg-udf-dl-test-eus2-01"
    subnet_id = "/subscriptions/551c97e4-16ee-42dd-aa06-297f70864146/resourceGroups/rg-udf-dl-net-sx-eus2-01/providers/Microsoft.Network/virtualNetworks/vnet-udf-dl-sx-eus2-01/subnets/snet-udf-dl-misc-eus2-01"
  }
}

nsg_additional_tags = {
  iac = "Terraform"
}

## Route Tables

route_tables = {
  rt1 = {
    name                          = "rt-udf-dl-eus2-01"
    location                      = "East US 2"
    disable_bgp_route_propagation = true
    subnet_name                   = "snet-udf-dl-misc-eus2-01"
    vnet_name                     = "vnet-udf-dl-sx-eus2-01"
    routes = [{
      name                   = "default"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "Internet"
      next_hop_in_ip_address = null
      azure_firewall_name    = null
    }]
  }
}

route_table_tags = {
  iac = "Terraform"
}

## Key Vaults

keyvaults = {
  "kv_1" = {
    keyvault_name                 = "kvudfdleus2001"
    location                      = "East US 2"
    resource_group_name           = "rg-udf-dl-runtime-sx-eus2-01"
    kv_sku_name                   = "standard"
    purge_protection              = true
    public_network_access_enabled = true
  }
}

access_policies = {
  "accp1" = {
    keyvault_name           = "kvudfdleus2001"
    group_names             = []
    object_id               = "3b760f42-6e03-4a11-83c6-e6c51ece6f7a"
    user_principal_names    = []
    certificate_permissions = ["Get", "List"]
    key_permissions         = ["Get", "List", "Create"]
    secret_permissions      = ["Get", "List", "Set"]
    storage_permissions     = ["Backup", "Get", "List", "ListSAS", "Recover", "Restore"]
  },
  "accp2" = {
    keyvault_name           = "kvudfdleus2001"
    group_names             = []
    object_id               = "3297d4a1-ef85-40d6-b38b-18ee6ba197f3"
    user_principal_names    = []
    certificate_permissions = ["Get", "List"]
    key_permissions         = ["Get", "List"]
    secret_permissions      = ["Get", "List", "Set"]
    storage_permissions     = ["Backup", "Get", "List", "ListSAS", "Recover", "Restore"]
  }
}

secrets = {}

kv_additional_tags = {
  iac = "Terraform"
}

## Data Factory

data_factory = {
  data_factory1 = {
    name                            = "df-integration-sx-eus2-01"
    location                        = "East US 2"
    resource_group_name             = "rg-udf-dl-integration-sx-eus2-01"
    assign_identity                 = "true"
    public_network_enabled          = "false"
    managed_virtual_network_enabled = "true"
    github_configuration            = []
  },
  data_factory2 = {
    name                            = "df-runtime-sx-eus2-01"
    location                        = "East US 2"
    resource_group_name             = "rg-udf-dl-runtime-sx-eus2-01"
    assign_identity                 = "true"
    public_network_enabled          = "false"
    managed_virtual_network_enabled = "true"
    github_configuration            = []
  }
}

data_factory_integration_runtime_azure = {
  data_factory_integration_runtime_azure1 = {
    name              = "AutoResolveIntegrationRuntime"
    data_factory_name = "df-integration-sx-eus2-01"
    location          = "AutoResolve"
    compute_type      = "MemoryOptimized"
    core_count        = 8
    ttl               = 10
  },
  data_factory_integration_runtime_azure2 = {
    name              = "AutoResolveIntegrationRuntime"
    data_factory_name = "df-runtime-sx-eus2-01"
    location          = "AutoResolve"
    compute_type      = "MemoryOptimized"
    core_count        = 8
    ttl               = 10
  }
}

adf_additional_tags = {
  iac = "Terraform"
}

## Diagnostics settings for Datafactory

diagnostic_settings_datafactory = {
  diagnostic_settings1 = {
    name      = "ADF_INTEGRATION_DIAGNOSTICS"
    target_id = "/subscriptions/551c97e4-16ee-42dd-aa06-297f70864146/resourceGroups/rg-udf-dl-integration-sx-eus2-01/providers/Microsoft.DataFactory/factories/df-integration-sx-eus2-01"
  },
  diagnostic_settings2 = {
    name      = "ADF_RUNTIME_DIAGNOSTICS"
    target_id = "/subscriptions/551c97e4-16ee-42dd-aa06-297f70864146/resourceGroups/rg-udf-dl-runtime-sx-eus2-01/providers/Microsoft.DataFactory/factories/df-runtime-sx-eus2-01"
  }
}

law_workspace_id = "/subscriptions/551c97e4-16ee-42dd-aa06-297f70864146/resourceGroups/rg-udf-monitoring-eus2-01/providers/Microsoft.OperationalInsights/workspaces/law-udf-dm-eus2-001"

## Databricks

networking_resource_group = "rg-udf-dl-net-sx-eus2-01"

databricks_workspaces = {
  ws1 = {
    name                                  = "dbx-integration-sx-eus2-01"
    location                              = "East US 2"
    resource_group_name                   = "rg-udf-dl-integration-sx-eus2-01"
    sku                                   = "premium"
    managed_resource_group_name           = null
    public_network_access_enabled         = "false"
    network_security_group_rules_required = "NoAzureDatabricksRules"
    custom_parameters = {
      virtual_network_name           = "vnet-udf-dl-sx-eus2-01"
      virtual_network_resource_group = "rg-udf-dl-net-sx-eus2-01"
      private_subnet_name            = "snet-udf-dl-dbx-pri-eus2-01"
      public_subnet_name             = "snet-udf-dl-dbx-pub-eus2-01"
      no_public_ip                   = "true"
      storage_account_name           = null
      storage_account_sku_name       = "Standard_GRS"
      vnet_address_prefix            = "null"
    }
  }
}

network_security_groups_private = {
  private_nsg1 = {
    name                      = "nsg-dbx-integration-sx-private-eus2-01"
    location                  = "East US 2"
    resource_group_name       = "rg-udf-dl-integration-sx-eus2-01"
    subnet_name               = "snet-udf-dl-dbx-pri-eus2-01"
    vnet_name                 = "vnet-udf-dl-sx-eus2-01"
    networking_resource_group = "rg-udf-dl-net-sx-eus2-01"
    security_rules            = []
  }
}

network_security_groups_public = {
  public_nsg1 = {
    name                      = "nsg-dbx-integration-sx-public-eus2-01"
    location                  = "East US 2"
    resource_group_name       = "rg-udf-dl-integration-sx-eus2-01"
    subnet_name               = "snet-udf-dl-dbx-pub-eus2-01"
    vnet_name                 = "vnet-udf-dl-sx-eus2-01"
    networking_resource_group = "rg-udf-dl-net-sx-eus2-01"
    security_rules            = []
  }
}

databricks_additional_tags = {
  iac = "Terraform"
}

nsg_tags = {
  iac = "Terraform"
}

diagnostic_settings_databricks = {
  diagnostic_settings1 = {
    name      = "DBX_Logging_1"
    target_id = "/subscriptions/551c97e4-16ee-42dd-aa06-297f70864146/resourceGroups/rg-udf-dl-integration-sx-eus2-01/providers/Microsoft.Databricks/workspaces/dbx-integration-sx-eus2-01"
  }
}

### Windows Virtual Machine

resource_group_name_vm  = "rg-udf-dl-runtime-sx-eus2-01"
key_vault_name          = "kvudfdleus2001"
Keyvault_resource_group = "rg-udf-dl-runtime-sx-eus2-01"

windows_vms = {
  vm1 = {
    name                                 = "shirvm"
    computer_name                        = "shirvm"
    vm_size                              = "Standard_DS2"
    assign_identity                      = true
    availability_set_key                 = null
    vm_nic_keys                          = ["nic1"]
    zone                                 = null
    source_image_reference_offer         = "WindowsServer"          # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer
    source_image_reference_publisher     = "MicrosoftWindowsServer" # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer  
    source_image_reference_sku           = "2016-Datacenter"        # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer 
    source_image_reference_version       = "latest"                 # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer             
    os_disk_name                         = "shirvm-os"
    storage_os_disk_caching              = "ReadWrite"
    managed_disk_type                    = "Premium_LRS"
    disk_size_gb                         = null
    write_accelerator_enabled            = null
    recovery_services_vault_name         = null #"tfex-recovery-vault"
    vm_backup_policy_name                = null #"tfex-recovery-vault-policy"
    use_existing_disk_encryption_set     = false
    existing_disk_encryption_set_name    = null
    existing_disk_encryption_set_rg_name = null
    customer_managed_key_name            = null
    disk_encryption_set_name             = null
    enable_cmk_disk_encryption           = true # set it to true if you want to enable disk encryption using customer managed key
    enable_automatic_updates             = true
    custom_data_path                     = null #"//script_file.ps1" # Optional
    custom_data_args                     = null #"{ name = "VMandVM", destination = "EASTUS2", version = "1.0" }    
  }
}
windows_vm_nics = {
  nic1 = {
    name                           = "shirvm-nic-01"
    subnet_name                    = "snet-udf-dl-misc-eus2-01"
    subnet_id                      = "/subscriptions/551c97e4-16ee-42dd-aa06-297f70864146/resourceGroups/rg-udf-dl-net-sx-eus2-01/providers/Microsoft.Network/virtualNetworks/vnet-udf-dl-sx-eus2-01/subnets/snet-udf-dl-misc-eus2-01"
    vnet_name                      = "vnet-udf-dl-sx-eus2-01"
    networking_resource_group      = "rg-udf-dl-net-sx-eus2-01"
    lb_backend_pool_names          = null
    lb_nat_rule_names              = null
    app_security_group_names       = null
    app_gateway_backend_pool_names = null
    internal_dns_name_label        = null
    enable_ip_forwarding           = null # set it to true if you want to enable IP forwarding on the NIC
    enable_accelerated_networking  = null # set it to true if you want to enable accelerated networking
    dns_servers                    = null
    nic_ip_configurations = [
      {
        static_ip = null
        name      = "ip-config-shir-01"
      }
    ]
  }
}
win_administrator_user_name = "winvmitadmin"
key_vault_id                = "/subscriptions/551c97e4-16ee-42dd-aa06-297f70864146/resourceGroups/rg-udf-dl-runtime-sx-eus2-01/providers/Microsoft.KeyVault/vaults/kvudfdleus2001"
managed_data_disks = {
  "disk1" = {
    disk_name                 = "shirvm-datadisk-1"
    vm_key                    = "vm1"
    lun                       = 0
    storage_account_type      = "Standard_LRS"
    disk_size                 = "512"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  }
}

vm_additional_tags = {
  iac = "Terraform"
}

##SYNAPSE WORKSPACE

adls2                    = "synwsadls"
synstorageaccountname    = "studfsxeus201bronze"
storage_resource_group   = "rg-udf-dl-storage-sx-eus2-01"
key_vault_resource_group = "rg-udf-dl-runtime-sx-eus2-01"

synapse_workspaces = {
  sw1 = {
    name                                 = "asa-integration-sx-eus2-01"
    resource_group_name                  = "rg-udf-dl-integration-sx-eus2-01"
    location                             = "East US 2"
    SQLUsername                          = "sqladmin"
    mrgname                              = "synwsmanagedrg"
    managed_virtual_network_enabled      = "true"
    public_network_access_enabled        = "false"
    data_exfiltration_protection_enabled = "true"
    assign_identity                      = "true"
  }
}

syn_additional_tags = {
  iac = "Terraform"
}