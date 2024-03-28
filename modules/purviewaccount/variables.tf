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