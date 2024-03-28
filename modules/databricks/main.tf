// Create the databricks workspace
data "azurerm_resource_group" "this" {
  for_each = var.databricks_workspaces
  name     = each.value["resource_group_name"]
}

data "azurerm_resource_group" "subnet_rg" {
  name = var.networking_resource_group
}

data "azurerm_virtual_network" "vnet" {
  for_each            = var.databricks_workspaces
  name                = each.value["custom_parameters"].virtual_network_name
  resource_group_name = each.value["custom_parameters"].virtual_network_resource_group
}

data "azurerm_subnet" "private_subnet" {
  for_each             = var.databricks_workspaces
  name                 = each.value["custom_parameters"].private_subnet_name
  virtual_network_name = each.value["custom_parameters"].virtual_network_name
  resource_group_name  = each.value["custom_parameters"].virtual_network_resource_group
}

data "azurerm_subnet" "public_subnet" {
  for_each             = var.databricks_workspaces
  name                 = each.value["custom_parameters"].public_subnet_name
  virtual_network_name = each.value["custom_parameters"].virtual_network_name
  resource_group_name  = each.value["custom_parameters"].virtual_network_resource_group
}

data "azurerm_subnet" "private" {
  for_each             = local.subnet_network_security_group_associations_private
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = data.azurerm_resource_group.subnet_rg.name
}

data "azurerm_subnet" "public" {
  for_each             = local.subnet_network_security_group_associations_public
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = data.azurerm_resource_group.subnet_rg.name
}

locals {
  tags     = var.databricks_additional_tags
  nsg_tags = var.nsg_tags
  nsg_pri  = { for nsg in azurerm_network_security_group.databricks-subnet-private-sg : nsg.name => nsg.id }
  nsg_pub  = { for nsg in azurerm_network_security_group.databricks-subnet-public-sg : nsg.name => nsg.id }
}

resource "azurerm_databricks_workspace" "databricks_ws" {
  for_each                              = var.databricks_workspaces
  name                                  = each.value["name"]
  resource_group_name                   = each.value["resource_group_name"]
  location                              = each.value["location"]
  sku                                   = each.value["sku"]
  managed_resource_group_name           = each.value["managed_resource_group_name"]
  public_network_access_enabled         = each.value["public_network_access_enabled"]
  network_security_group_rules_required = each.value["network_security_group_rules_required"]

  custom_parameters {
    no_public_ip                                         = each.value["custom_parameters"]["no_public_ip"] != null ? each.value["custom_parameters"]["no_public_ip"] : true
    private_subnet_name                                  = each.value["custom_parameters"].private_subnet_name
    public_subnet_network_security_group_association_id  = data.azurerm_subnet.public_subnet[each.key].id
    private_subnet_network_security_group_association_id = data.azurerm_subnet.private_subnet[each.key].id
    public_subnet_name                                   = each.value["custom_parameters"].public_subnet_name
    virtual_network_id                                   = data.azurerm_virtual_network.vnet[each.key].id
    vnet_address_prefix                                  = each.value["custom_parameters"]["vnet_address_prefix"] != null ? each.value["custom_parameters"]["vnet_address_prefix"] : null ##Set this VNET address prefix if VNET ID is not given.
    storage_account_name                                 = each.value["custom_parameters"]["storage_account_name"] != null ? each.value["custom_parameters"]["storage_account_name"] : null
    storage_account_sku_name                             = each.value["custom_parameters"]["storage_account_sku_name"] != null ? each.value["custom_parameters"]["storage_account_sku_name"] : "Standard_GRS"
  }
  lifecycle {
    ignore_changes = [
      custom_parameters
    ]
  }

  tags       = local.tags
  depends_on = [azurerm_subnet_network_security_group_association.private-subnet-sg-association, azurerm_subnet_network_security_group_association.public-subnet-sg-association]
}

locals {
  subnet_network_security_group_associations_private = {
    for k, v in var.network_security_groups_private : k => v if(v.subnet_name != null)
  }

  subnet_network_security_group_associations_public = {
    for k, v in var.network_security_groups_public : k => v if(v.subnet_name != null)
  }
}

// Create the security groups and make the associations with the subnets
resource "azurerm_network_security_group" "databricks-subnet-private-sg" {
  for_each            = var.network_security_groups_private
  name                = each.value["name"]
  location            = each.value["location"]
  resource_group_name = each.value["resource_group_name"]
  tags                = local.nsg_tags
}

resource "azurerm_subnet_network_security_group_association" "private-subnet-sg-association" {
  for_each                  = local.subnet_network_security_group_associations_private
  subnet_id                 = lookup(data.azurerm_subnet.private, each.key)["id"]
  network_security_group_id = azurerm_network_security_group.databricks-subnet-private-sg[each.key]["id"]
  lifecycle {
    ignore_changes = [
      subnet_id
    ]
  }
}

resource "azurerm_network_security_group" "databricks-subnet-public-sg" {
  for_each            = var.network_security_groups_public
  name                = each.value["name"]
  location            = each.value["location"]
  resource_group_name = each.value["resource_group_name"]
  tags                = local.nsg_tags
}

resource "azurerm_subnet_network_security_group_association" "public-subnet-sg-association" {
  for_each                  = local.subnet_network_security_group_associations_public
  subnet_id                 = lookup(data.azurerm_subnet.public, each.key)["id"]
  network_security_group_id = azurerm_network_security_group.databricks-subnet-public-sg[each.key]["id"]
  lifecycle {
    ignore_changes = [
      subnet_id
    ]
  }
}