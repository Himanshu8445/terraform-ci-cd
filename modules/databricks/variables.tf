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