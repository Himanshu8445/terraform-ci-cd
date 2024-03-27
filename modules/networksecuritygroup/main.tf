locals {
  nsg_map = { for nsg in azurerm_network_security_group.this : nsg.name => nsg.id }
  tags    = var.nsg_additional_tags
}

##Network Security Group

resource "azurerm_network_security_group" "this" {
  for_each            = var.network_security_groups
  name                = each.value["name"]
  location            = each.value["location"]
  resource_group_name = each.value["resource_group_name"]
  lifecycle {
    ignore_changes = [
      security_rule
    ]
  }
  dynamic "security_rule" {
    for_each = lookup(each.value, "security_rules", [])
    content {
      name                         = security_rule.value["name"]
      description                  = lookup(security_rule.value, "description", null)
      protocol                     = coalesce(security_rule.value["protocol"], "Tcp")
      direction                    = security_rule.value["direction"]
      access                       = coalesce(security_rule.value["access"], "Allow")
      priority                     = security_rule.value["priority"]
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
      source_port_range            = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_range       = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", null)
    }
  }

  tags = local.tags
}

# Associates a Network Security Group with a Subnet within a Virtual Network

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = var.nsg_subnet_association
  network_security_group_id = local.nsg_map[each.value.nsg_name]
  subnet_id                 = each.value["subnet_id"]
  depends_on                = [azurerm_network_security_group.this]
}