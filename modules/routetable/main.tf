data "azurerm_resource_group" "this" {
  name = var.resource_group_name_network
}

data "azurerm_subnet" "this" {
  for_each             = local.subnet_route_table_associations
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = data.azurerm_resource_group.this.name
}

# -
# - Route Table
# -
resource "azurerm_route_table" "this" {
  for_each                      = var.route_tables
  name                          = each.value["name"]
  location                      = each.value["location"]
  resource_group_name           = data.azurerm_resource_group.this.name
  disable_bgp_route_propagation = lookup(each.value, "disable_bgp_route_propagation", null)

  dynamic "route" {
    for_each = lookup(each.value, "routes", [])
    content {
      name                   = lookup(route.value, "name", null)
      address_prefix         = lookup(route.value, "address_prefix", null)
      next_hop_type          = lookup(route.value, "next_hop_type", null)
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }

  tags = local.tags
}

locals {
  subnet_route_table_associations = {
    for k, v in var.route_tables : k => v if(v.subnet_name != null)
  }

  tags = var.route_table_tags
}


# Associates a Route Table with a Subnet within a Virtual Network
resource "azurerm_subnet_route_table_association" "this" {
  for_each       = local.subnet_route_table_associations
  route_table_id = azurerm_route_table.this[each.key]["id"]
  subnet_id      = lookup(data.azurerm_subnet.this, each.key)["id"]
  lifecycle {
    ignore_changes = [
      subnet_id
    ]
  }
}
