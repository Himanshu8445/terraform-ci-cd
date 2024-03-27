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

## Route Table

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

## Data Factory

variable "data_factory" {
  type = map(object({
    name                            = string
    location                        = string
    resource_group_name             = string
    assign_identity                 = bool
    public_network_enabled          = bool
    managed_virtual_network_enabled = bool
    github_configuration = list(object({
      account_name    = string
      branch_name     = string
      git_url         = string
      repository_name = string
      root_folder     = string
    }))
  }))
  default = {}
}

variable "adf_additional_tags" {
  type        = map(string)
  description = "Additional tags for data factory"
  default     = {}
}

variable "data_factory_integration_runtime_azure" {
  type = map(object({
    name              = string
    data_factory_name = string
    location          = string
    compute_type      = string
    core_count        = number
    ttl               = number
  }))
  default = {}
}

## Data Factory Diagnostics

variable "law_workspace_id" {
  type        = string
  description = <<EOT
  log Analytics workspace Diagnostic Logs will be sent to.
  Example: /subscriptions/<subscription id>/resourceGroups/<resource group>/providers/Microsoft.OperationalInsights/workspaces/<workspace name>
  EOT
}

variable "diagnostic_settings_datafactory" {
  type = map(object({
    name      = string
    target_id = string
  }))
}

# Log categories  
variable "activity_run" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "pipeline_runs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}
variable "trigger_runs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}
variable "sandbox_pipeline_runs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "sandbox_activity_runs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssis_package_event_msgs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssis_exe_stats" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssip_package_event_msg_context" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssis_package_exe_component_phases" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssis_package_exe_data_stats" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssis_integration_runtime_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "data_factory_metrics" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

## Databricks 

variable "databricks_workspaces" {
  description = "databricks_workspaces"
  type = map(object({
    name                                  = string # (Required) Specifies the name of the Databricks Workspace resource.
    location                              = string # (Required) Specifies the location for workspace
    resource_group_name                   = string # (Required) Databricks Workspace resource group.
    sku                                   = string # (Required) The sku to use for the Databricks Workspace. Possible values are standard, premium, or trial
    managed_resource_group_name           = string # (Optional) The name of the resource group where Azure should place the managed Databricks resources.
    public_network_access_enabled         = bool
    network_security_group_rules_required = string
    custom_parameters = object({
      virtual_network_name           = string # Name of the vnet to be used by databricks
      virtual_network_resource_group = string # Name of the vnet rg
      private_subnet_name            = string # Name of the private subnet to be used by databricks
      public_subnet_name             = string # Name of the public subnet to be used by databricks   
      no_public_ip                   = bool   # (Optional) Are public IP Addresses not allowed? Possible values are true or false. Defaults to false. Changing this forces a new resource to be created.
      storage_account_name           = string # (Optional) Default Databricks File Storage account name. Defaults to a randomized name(e.g. dbstoragel6mfeghoe5kxu). Changing this forces a new resource to be created.
      storage_account_sku_name       = string # (Optional) Storage account SKU name. Possible values include Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_GZRS, Standard_RAGZRS, Standard_ZRS, Premium_LRS or Premium_ZRS. Defaults to Standard_GRS. Changing this forces a new resource to be created.
      vnet_address_prefix            = string # (Optional) Address prefix for Managed virtual network. Defaults to 10.139. Changing this forces a new resource to be created.
    })
  }))
  default = {}
}

variable "network_security_groups_private" {
  type = map(object({
    name                      = string
    location                  = string
    resource_group_name       = string
    subnet_name               = string
    vnet_name                 = string
    networking_resource_group = string
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

variable "network_security_groups_public" {
  type = map(object({
    name                      = string
    location                  = string
    resource_group_name       = string
    subnet_name               = string
    vnet_name                 = string
    networking_resource_group = string
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

variable "networking_resource_group" {
  type        = string
  description = "Subnet resource_group_name"
}

variable "databricks_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
}

variable "nsg_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
}

## Databricks Diagnostics

variable "diagnostic_settings_databricks" {
  type = map(object({
    name      = string
    target_id = string
  }))
}

# Log categories  
variable "databricks_dbfs_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_cluster_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}
variable "databricks_account_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}
variable "databricks_jobs_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_notebook_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_ssh_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_workspace_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_secrets_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_sql_permissions_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
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

## Windows Virtual Machine

variable "resource_group_name_vm" {
  type        = string
  description = "Specifies the name of the Resource Group in which the Windows Virtual Machine should exist"
}

variable "vm_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "key_vault_id" {
  type = string
}

# -
# - Windows VM's
# -
variable "windows_vms" {
  type = map(object({
    name                                 = string
    computer_name                        = string
    vm_size                              = string
    zone                                 = string
    assign_identity                      = bool
    availability_set_key                 = string
    vm_nic_keys                          = list(string)
    source_image_reference_publisher     = string
    source_image_reference_offer         = string
    source_image_reference_sku           = string
    source_image_reference_version       = string
    os_disk_name                         = string
    storage_os_disk_caching              = string
    managed_disk_type                    = string
    disk_size_gb                         = number
    write_accelerator_enabled            = bool
    recovery_services_vault_name         = string
    vm_backup_policy_name                = string
    use_existing_disk_encryption_set     = bool
    existing_disk_encryption_set_name    = string
    existing_disk_encryption_set_rg_name = string
    enable_cmk_disk_encryption           = bool
    customer_managed_key_name            = string
    disk_encryption_set_name             = string
    enable_automatic_updates             = bool
    custom_data_path                     = string
    custom_data_args                     = map(string)
  }))
  description = "Map containing Windows VM objects"
  default     = {}
}

variable "windows_vm_nics" {
  type = map(object({
    name                           = string
    subnet_name                    = string
    subnet_id                      = string
    vnet_name                      = string
    networking_resource_group      = string
    lb_backend_pool_names          = list(string)
    lb_nat_rule_names              = list(string)
    app_security_group_names       = list(string)
    app_gateway_backend_pool_names = list(string)
    internal_dns_name_label        = string
    enable_ip_forwarding           = bool
    enable_accelerated_networking  = bool
    dns_servers                    = list(string)
    nic_ip_configurations = list(object({
      name      = string
      static_ip = string
    }))
  }))
  description = "Map containing Windows VM NIC objects"
  default     = {}
}

variable "win_administrator_user_name" {
  type        = string
  description = "Specifies the name of the local administrator account"
}

# -
# - Availability Sets
# -
variable "availability_sets" {
  type = map(object({
    name                         = string
    platform_update_domain_count = number
    platform_fault_domain_count  = number
  }))
  description = "Map containing availability set configurations"
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

# -
# - Managed Disks
# -
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
############################
# State File
############################ 
variable "ackey" {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
/* variable "loganalytics_resource_group" {
  type        = string
  description = "Specifies the name of the Log Analytics resource group in which the Linux Virtual Machine should exist"
  default = null
} */
/* variable "storage_resource_group" {
  type        = string
  description = "Specifies the name of the storage resource group in which the Linux Virtual Machine should exist"
} */
variable "Keyvault_resource_group" {
  type        = string
  description = "Specifies the name of the key vault resource group"
  default     = null
}

## SYNAPSE WORKSPACE

variable "syn_additional_tags" {
  type        = map(string)
  description = "Tags of the Synapse Workspace in addition to the resource group tag."
  default = {
    pe_enable = true
  }
}

variable "key_vault_resource_group" {
  type        = string
  description = "Specifies KV resource group."
  default     = null
}

variable "expiration_date" {
  type        = string
  description = "Specifies the expiration date for secret."
  default     = null
}

variable "content_type" {
  type        = string
  description = "Specifies the content type of secret."
  default     = null
}

variable "adls2" {
  type        = string
  description = "Specifies adls file system."
  default     = null
}

variable "storage_resource_group" {
  type        = string
  description = "Specifies storage account resource group."
  default     = null
}

variable "synstorageaccountname" {
  type        = string
  description = "Specifies storage account name."
  default     = null
}

variable "synapse_workspaces" {
  type = map(object({
    name                                 = string
    resource_group_name                  = string
    location                             = string
    mrgname                              = string
    SQLUsername                          = string
    managed_virtual_network_enabled      = bool
    public_network_access_enabled        = bool
    data_exfiltration_protection_enabled = bool
    assign_identity                      = bool
  }))
  description = "Map of synapse workspace which needs to be created in a resource group"
}
