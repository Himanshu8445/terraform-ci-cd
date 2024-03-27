/* variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Synapse Workspace"
} */

variable "syn_additional_tags" {
  type        = map(string)
  description = "Tags of the Synapse Workspace in addition to the resource group tag."
  default = {
    pe_enable = true
  }
}

variable "key_vault_name" {
  type        = string
  description = "Specifies the existing Key Vault Name where you want to store SQL password."
  default     = null
}

variable "key_vault_resource_group" {
  type        = string
  description = "Specifies the resource group for key vault."
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

############################
# State File
############################ 
variable "ackey" {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
