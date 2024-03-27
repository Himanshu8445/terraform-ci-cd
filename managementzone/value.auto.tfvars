resource_groups = {
  rg_runner = {
    name     = "rg-udf-deploy-eus2-01"
    location = "East US 2"
    tags = {
      iac = "Terraform"
    }
  },
  rg_vnet = {
    name     = "rg-udf-dm-net-sx-eus2-01"
    location = "East US 2"
    tags = {
      iac = "Terraform"
    }
  },
  rg_kv = {
    name     = "rg-udf-dm-governance-sx-eus2-01"
    location = "East US 2"
    tags = {
      iac = "Terraform"
    }
  },
  rg_monitoring = {
    name     = "rg-udf-monitoring-eus2-01"
    location = "East US 2"
    tags = {
      iac = "Terraform"
    }
  }
}

### Virtual Network

resource_group_name_network = "rg-udf-dm-net-sx-eus2-01"

virtual_networks = {
  vnet_1 = {
    name                 = "vnet-udf-dm-sx-eus2-01"
    location             = "East US 2"
    address_space        = ["10.10.0.0/16"]
    dns_servers          = null
    ddos_protection_plan = null
  }
}

subnets = {
  subnet1 = {
    vnet_key          = "vnet_1"
    vnet_name         = "vnet-udf-dm-sx-eus2-01"
    name              = "snet-udf-dm-runner-eus2-01"
    address_prefixes  = ["10.10.1.0/26"]
    service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    pe_enable         = false
    delegation        = null
  },
  subnet2 = {
    vnet_key          = "vnet_1"
    vnet_name         = "vnet-udf-dm-sx-eus2-01"
    name              = "AzureBastionSubnet"
    address_prefixes  = ["10.10.2.0/26"]
    service_endpoints = []
    pe_enable         = false
    delegation        = null
  },
  subnet3 = {
    vnet_key          = "vnet_1"
    vnet_name         = "vnet-udf-dm-sx-eus2-01"
    name              = "snet-udf-dm-misc-eus2-01"
    address_prefixes  = ["10.10.3.0/26"]
    service_endpoints = []
    pe_enable         = false
    delegation        = null
  }
}

vnet_tags = {
  iac = "Terraform"
}

## Network Security Group

network_security_groups = {
  nsg1 = {
    name                = "nsg-udf-dm-runner-eus2-01"
    location            = "East US 2"
    resource_group_name = "rg-udf-dm-net-sx-eus2-01"
    security_rules      = []
  }
}

nsg_subnet_association = {
  nsg_subnet_association_1 = {
    nsg_name  = "nsg-udf-dm-runner-eus2-01"
    subnet_id = "/subscriptions/551c97e4-16ee-42dd-aa06-297f70864146/resourceGroups/rg-udf-dm-net-sx-eus2-01/providers/Microsoft.Network/virtualNetworks/vnet-udf-dm-sx-eus2-01/subnets/snet-udf-dm-runner-eus2-01"
  }
}

nsg_additional_tags = {
  iac = "Terraform"
}

## Route Tables

route_tables = {
  rt1 = {
    name                          = "rt-udf-dm-eus2-01"
    location                      = "East US 2"
    disable_bgp_route_propagation = true
    subnet_name                   = "snet-udf-dm-misc-eus2-01"
    vnet_name                     = "vnet-udf-dm-sx-eus2-01"
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

## Key Vault

keyvaults = {
  "kv_1" = {
    keyvault_name                 = "kvudfdmeus2001"
    location                      = "East US 2"
    resource_group_name           = "rg-udf-dm-governance-sx-eus2-01"
    kv_sku_name                   = "standard"
    purge_protection              = true
    public_network_access_enabled = true
  }
}

access_policies = {
  "accp1" = {
    keyvault_name           = "kvudfdmeus2001"
    group_names             = []
    object_id               = "3b760f42-6e03-4a11-83c6-e6c51ece6f7a"
    user_principal_names    = []
    certificate_permissions = ["Get", "List"]
    key_permissions         = ["Get", "List"]
    secret_permissions      = ["Get", "List", "Set"]
    storage_permissions     = ["Backup", "Get", "List", "ListSAS", "Recover", "Restore"]
  },
  "accp2" = {
    keyvault_name           = "kvudfdmeus2001"
    group_names             = []
    object_id               = "3297d4a1-ef85-40d6-b38b-18ee6ba197f3"
    user_principal_names    = []
    certificate_permissions = ["Get", "List"]
    key_permissions         = ["Get", "List"]
    secret_permissions      = ["Get", "List"]
    storage_permissions     = ["Backup", "Get", "List", "ListSAS", "Recover", "Restore"]
  }
}

secrets = {}

kv_additional_tags = {
  iac = "Terraform"
}

###### Linux Virtual Machine

resource_group_name_vm  = "rg-udf-deploy-eus2-01"
key_vault_name          = "kvudfdmeus2001"
Keyvault_resource_group = "rg-udf-dm-governance-sx-eus2-01"

linux_vms = {
  vm1 = {
    name                                 = "runner1" //Computer name
    vm_size                              = "Standard_DS2"
    assign_identity                      = true
    availability_set_key                 = null
    vm_nic_keys                          = ["nic1"]
    zone                                 = null
    disable_password_authentication      = true
    source_image_reference_offer         = "RHEL"   # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer
    source_image_reference_publisher     = "RedHat" # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer  
    source_image_reference_sku           = "8_5"    #"18.04-LTS"    # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer 
    source_image_reference_version       = "latest" # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer             
    os_disk_name                         = "runner1-os"
    storage_os_disk_caching              = "ReadWrite"
    managed_disk_type                    = "StandardSSD_LRS"
    disk_size_gb                         = null
    write_accelerator_enabled            = null
    enable_cmk_disk_encryption           = false
    ultra_ssd_enabled                    = false
    use_existing_ssh_key                 = false # set it to true if you want to use existing public ssh key
    secret_name_of_public_ssh_key        = null  # key vault secret name of existing public ssh key          # set it to true if you want to enable disk encryption using customer managed key
    use_existing_disk_encryption_set     = false
    existing_disk_encryption_set_name    = null
    existing_disk_encryption_set_rg_name = null
    custom_data_path                     = null #"//CustomData.tpl" # Optional
    custom_data_args                     = null #"{ name = "VMandVM", destination = "EASTUS2", version = "1.0" }
  }
}

linux_vm_nics = {
  nic1 = {
    name                           = "runner1-nic"
    subnet_name                    = "snet-udf-dm-runner-eus2-01"
    vnet_name                      = "vnet-udf-dm-sx-eus2-01"
    networking_resource_group      = "rg-udf-dm-net-sx-eus2-01"
    lb_nat_rules                   = null # #provide the name and resource IDs of the NAT rules
    app_security_group_names       = null
    app_gateway_backend_pool_names = null
    internal_dns_name_label        = null
    enable_ip_forwarding           = null # set it to true if you want to enable IP forwarding on the NIC
    enable_accelerated_networking  = null # set it to true if you want to enable accelerated networking
    dns_servers                    = null
    lb_backend_pools               = null
    nic_ip_configurations = [
      {
        static_ip = null
        name      = "ip-config-runner-001"
      }
    ]
  }
}


administrator_user_name      = "runneradmin"
administrator_login_password = null

# Existing SSH Keys
ssh_key_vault_name    = null # name of the key vault where public ssh key is stored
ssh_key_vault_rg_name = null # rg name of the key vault where public ssh key is stored
ado_subscription_id   = null

managed_data_disks = {}

vm_additional_tags = {
  iac = "Terraform"
}

## Storage Account

storage_accounts = {
  str_acct_1 = {
    name                            = "strudfdmeus2bs01"
    sku                             = "Standard_LRS"
    resource_group_name             = "rg-udf-monitoring-eus2-01"
    location                        = "East US 2"
    account_kind                    = null
    access_tier                     = null
    assign_identity                 = true
    cmk_enable                      = true
    min_tls_version                 = "TLS1_2"
    is_hns_enabled                  = "false"
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

## Log Analytics Workspace

resource_group_name_la  = "rg-udf-monitoring-eus2-01"
resource_group_name_str = "rg-udf-monitoring-eus2-01"
name                    = "law-udf-dm-eus2-001"
sku                     = "PerGB2018"
retention_in_days       = "60"
law_linked_strg_name    = "strudfdmeus2bs01"

law_additional_tags = {
  iac = "Terraform"
}

## Purview Account
purview_account = {
  purview_account_1 = {
    name                        = "udf-purview-account-eus2-01"
    location                    = "East US 2"
    resource_group_name         = "rg-udf-dm-governance-sx-eus2-01"
    public_network_enabled      = "false"
    managed_resource_group_name = null
    assign_identity             = "true"
    tags = {
      iac = "Terraform"
    }
  }
}