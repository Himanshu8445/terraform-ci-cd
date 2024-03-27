variable "resource_group_name_network" {
  type        = string
  description = "The name of the resource group in which to create the Route Tables."
}

# -
# - Route Table object
# -
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