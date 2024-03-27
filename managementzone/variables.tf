# - Resource Group
variable "resource_groups" {
  description = "Resource groups"
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
  default = {}
}

## Virtual Network

variable "resource_group_name_network" {
  type        = string
  description = "Specifies the name of the resource group in which to create the Azure Network Base Infrastructure Resources."
}

variable "vnet_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "virtual_networks" {
  description = "The virtal networks with their properties."
  type = map(object({
    name          = string
    location      = string
    address_space = list(string)
    dns_servers   = list(string)
    ddos_protection_plan = object({
      id     = string
      enable = bool
    })
  }))
  default = {}
}

variable "subnets" {
  description = "The virtal networks subnets with their properties."
  type = map(object({
    name              = string
    vnet_key          = string
    vnet_name         = string
    address_prefixes  = list(string)
    pe_enable         = bool
    service_endpoints = list(string)
    delegation = list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    }))
  }))
  default = {}
}

## Network Security Groups

variable "network_security_groups" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    security_rules = list(object({
      name                                         = string
      description                                  = string
      protocol                                     = string
      direction                                    = string
      access                                       = string
      priority                                     = number
      source_address_prefix                        = string
      source_address_prefixes                      = list(string)
      destination_address_prefix                   = string
      destination_address_prefixes                 = list(string)
      source_port_range                            = string
      source_port_ranges                           = list(string)
      destination_port_range                       = string
      destination_port_ranges                      = list(string)
      source_application_security_group_names      = list(string)
      destination_application_security_group_names = list(string)
    }))
  }))
  description = "The network security groups with their properties."
  default     = {}
}

variable "nsg_additional_tags" {
  type    = map(string)
  default = {}
}

variable "nsg_subnet_association" {
  type = map(object({
    nsg_name  = string
    subnet_id = string
  }))
}

# Route Table

variable "route_tables" {
  type = map(object({
    name                          = string
    location                      = string
    disable_bgp_route_propagation = bool
    subnet_name                   = string
    vnet_name                     = string
    routes = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
      azure_firewall_name    = string
    }))
  }))
  description = "The route tables with their properties."
  default     = {}
}

variable "subnet_route_table_associations" {
  type = map(object({
    name                          = string
    disable_bgp_route_propagation = bool
    subnet_name                   = string
    routes = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
      azure_firewall_name    = string
    }))
  }))
  description = "The route tables with their properties."
  default     = {}
}

variable "route_table_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "subnet_ids" {
  type        = map(string)
  description = "A map of subnet id's"
  default     = {}
}

variable "firewall_private_ips_map" {
  type        = map(string)
  description = "Specifies the Map of Azure Firewall Private Ip's"
  default     = {}
}

## Key Vault

variable "keyvaults" {
  type = map(object({
    keyvault_name                 = string
    location                      = string
    resource_group_name           = string
    kv_sku_name                   = string
    purge_protection              = bool
    public_network_access_enabled = bool
  }))
}

variable "kv_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

#########################
# Key Vault Access Policy
#########################
variable "access_policies" {
  type = map(object({
    group_names             = list(string)
    keyvault_name           = string
    object_id               = string
    user_principal_names    = list(string)
    certificate_permissions = list(string)
    key_permissions         = list(string)
    secret_permissions      = list(string)
    storage_permissions     = list(string)
  }))
  description = "A map of access policies for the Key Vault"
  default     = {}
}

variable "msi_object_id" {
  type        = string
  description = "The object id of the MSI used by the ADO agent"
  default     = null
}

########################
# Key Vault Serets
########################
variable "secrets" {
  type        = map(string)
  description = "A map of secrets for the Key Vault"
  default     = {}
}

## Linux Virtual Machine

variable "resource_group_name_vm" {
  type        = string
  description = "Specifies the name of the Resource Group in which the Linux Virtual Machine should exist"
}

variable "Keyvault_resource_group" {
  type        = string
  description = "Specifies the name of the key vault resource group in which the Linux Virtual Machine should exist"
}

variable "vm_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

# -
# - Linux VM's
# -
variable "linux_vms" {
  type = map(object({
    name                                 = string
    vm_size                              = string
    zone                                 = string
    assign_identity                      = bool
    availability_set_key                 = string
    vm_nic_keys                          = list(string)
    disable_password_authentication      = bool
    source_image_reference_publisher     = string
    source_image_reference_offer         = string
    source_image_reference_sku           = string
    source_image_reference_version       = string
    os_disk_name                         = string
    storage_os_disk_caching              = string
    managed_disk_type                    = string
    disk_size_gb                         = number
    write_accelerator_enabled            = bool
    enable_cmk_disk_encryption           = bool
    use_existing_ssh_key                 = bool
    secret_name_of_public_ssh_key        = string
    use_existing_disk_encryption_set     = bool
    existing_disk_encryption_set_name    = string
    existing_disk_encryption_set_rg_name = string
    ultra_ssd_enabled                    = bool
    custom_data_path                     = string
    custom_data_args                     = map(string)
  }))
  description = "Map containing Linux VM objects"
  default     = {}
}

variable "linux_vm_nics" {
  type = map(object({
    name                           = string
    subnet_name                    = string
    vnet_name                      = string
    networking_resource_group      = string
    app_security_group_names       = list(string)
    app_gateway_backend_pool_names = list(string)
    internal_dns_name_label        = string
    enable_ip_forwarding           = bool
    enable_accelerated_networking  = bool
    dns_servers                    = list(string)
    lb_backend_pools = list(object({
      name            = string
      backend_pool_id = string
    }))
    lb_nat_rules = list(object({
      name        = string
      nat_rule_id = string
    }))
    nic_ip_configurations = list(object({
      name      = string
      static_ip = string
    }))
  }))
  description = "Map containing Linux VM NIC objects"
  default     = {}
}

variable "administrator_user_name" {
  type        = string
  description = "Specifies the name of the local administrator account"
}

variable "administrator_login_password" {
  type        = string
  description = "Specifies the password associated with the local administrator account"
  default     = null
}

# - Availability Sets

variable "availability_sets" {
  type = map(object({
    name                         = string
    platform_update_domain_count = number
    platform_fault_domain_count  = number
  }))
  description = "Map containing availability set configurations"
  default     = {}
}
variable "managed_data_disks" {
  type = map(object({
    disk_name                 = string
    vm_key                    = string
    lun                       = string
    storage_account_type      = string
    disk_size                 = number
    caching                   = string
    write_accelerator_enabled = bool
    create_option             = string
    os_type                   = string
    source_resource_id        = string
  }))
  description = "Map containing storage data disk configurations"
  default     = {}
}

# -
# - Diagnostics Extensions
# -
/* variable "diagnostics_sa_name" {
  type        = string
  description = "The name of diagnostics storage account"
  default     = null
} */

variable "key_vault_name" {
  type        = string
  description = "Specifies the existing Key Vault Name where you want to store VM SSH Private Key."
  default     = null
}

variable "ssh_key_vault_name" {
  type        = string
  description = "Specifies the name of the Key Vault that conatins Linux VM SSH Keys"
  default     = null
}

variable "ssh_key_vault_rg_name" {
  type        = string
  description = "Specifies the resource group name of the Key Vault that conatins Linux VM SSH Keys"
  default     = null
}

variable "ado_subscription_id" {
  type        = string
  description = "Specifies the Subscription Id of ADO Key Vault"
  default     = null
}

variable "kv_role_assignment" {
  type        = bool
  description = "Grant VM MSI Reader Role in KV resource?"
  default     = false
}

variable "self_role_assignment" {
  type        = bool
  description = "Grant VM MSI Reader Role in VM resource ?"
  default     = false
}

############################
# State File
############################ 
variable "ackey" {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}

##Storage Account

variable "storage_accounts" {
  type = map(object({
    name                            = string
    sku                             = string
    resource_group_name             = string
    location                        = string
    account_kind                    = string
    access_tier                     = string
    assign_identity                 = bool
    cmk_enable                      = bool
    min_tls_version                 = string
    is_hns_enabled                  = bool
    large_file_share_enabled        = bool
    public_network_access_enabled   = bool
    allow_nested_items_to_be_public = bool
    network_rules = object({
      bypass                     = list(string) # (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None.
      default_action             = string       # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
      ip_rules                   = list(string) # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
      virtual_network_subnet_ids = list(string) # (Optional) One or more Subnet ID's which should be able to access this Key Vault.
    })
  }))
  description = "Map of storage accouts which needs to be created in a resource group"
  default     = {}
}

variable "containers" {
  type = map(object({
    name                  = string
    storage_account_name  = string
    container_access_type = string
  }))
  description = "Map of Storage Containers"
  default     = {}
}

variable "sa_additional_tags" {
  type        = map(string)
  description = "Tags of the SA in addition to the resource group tag."
  default = {
    pe_enable = true
  }
}

## Log Analytics

variable "resource_group_name_la" {
  type        = string
  description = "The name of the resource group in which the Log Analytics workspace is created"
}

variable "resource_group_name_str" {
  type        = string
  description = "The name of the resource group in which storage account is created"
}

############################
# log analytics
############################
variable "name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workspace"
}

variable "sku" {
  type        = string
  description = "Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018"
}

variable "retention_in_days" {
  type        = string
  description = "The workspace data retention in days. Possible values range between 30 and 730"
}

variable "law_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "law_linked_strg_name" {
  type        = string
  description = "Law linked storage account name"
}

##Purview Account

variable "purview_account" {
  description = "Azure Purview Account"
  type = map(object({
    name                        = string
    location                    = string
    resource_group_name         = string
    public_network_enabled      = bool
    managed_resource_group_name = string
    assign_identity             = bool
    tags                        = map(string)
  }))
  default = {}
}