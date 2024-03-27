resource "azurerm_purview_account" "this" {
  for_each                    = var.purview_account
  name                        = each.value["name"]
  location                    = each.value["location"]
  resource_group_name         = each.value["resource_group_name"]
  public_network_enabled      = each.value["public_network_enabled"]
  managed_resource_group_name = each.value["managed_resource_group_name"]
  tags                        = each.value["tags"]
 dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [] : [lookup(each.value, "assign_identity", false)]
    content {
      type = "SystemAssigned"
    }
  }
}