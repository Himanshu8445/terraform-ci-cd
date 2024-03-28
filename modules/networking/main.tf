data "azurerm_resource_group" "this" {
  name = var.resource_group_name_network
}

data "azurerm_virtual_network" "this" {
  for_each            = local.existing_vnets
  name                = each.value
  resource_group_name = data.azurerm_resource_group.this.name
}

locals {
  existing_vnets = {
    for subnet_k, subnet_v in var.subnets :
    subnet_k => subnet_v.vnet_name if(subnet_v.vnet_key == null && subnet_v.vnet_name != null)
  }

  tags = var.vnet_tags
}

## Virtual Network

resource "azurerm_virtual_network" "this" {
  for_each            = var.virtual_networks
  name                = each.value["name"]
  location            = each.value["location"]
  resource_group_name = data.azurerm_resource_group.this.name
  address_space       = each.value["address_space"]
  dns_servers         = lookup(each.value, "dns_servers", null)

  dynamic "ddos_protection_plan" {
    for_each = lookup(each.value, "ddos_protection_plan", null) != null ? list(lookup(each.value, "ddos_protection_plan")) : []
    content {
      id     = lookup(ddos_protection_plan.value, "id", null)
      enable = coalesce(lookup(ddos_protection_plan.value, "enable"), false)
    }
  }

  tags = local.tags
}

## Subnet

resource "azurerm_subnet" "this" {
  for_each                                      = var.subnets
  name                                          = each.value["name"]
  resource_group_name                           = data.azurerm_resource_group.this.name
  address_prefixes                              = each.value["address_prefixes"]
  service_endpoints                             = coalesce(lookup(each.value, "pe_enable"), false) == false ? lookup(each.value, "service_endpoints", null) : null
  private_endpoint_network_policies_enabled     = coalesce(lookup(each.value, "pe_enable"), false)
  private_link_service_network_policies_enabled = coalesce(lookup(each.value, "pe_enable"), false)
  virtual_network_name                          = each.value.vnet_key != null ? lookup(var.virtual_networks, each.value["vnet_key"])["name"] : data.azurerm_virtual_network.this[each.key].name

  dynamic "delegation" {
    for_each = coalesce(lookup(each.value, "delegation"), [])
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = coalesce(lookup(delegation.value, "service_delegation"), [])
        content {
          name    = lookup(service_delegation.value, "name", null)
          actions = lookup(service_delegation.value, "actions", null)
        }
      }
    }
  }
  depends_on = [azurerm_virtual_network.this]
}
