locals {
  tags    = var.adf_additional_tags
  adf_map = { for adf in azurerm_data_factory.this : adf.name => adf.id }
}

resource "azurerm_data_factory" "this" {
  for_each                        = var.data_factory
  name                            = each.value["name"]
  location                        = each.value["location"]
  resource_group_name             = each.value["resource_group_name"]
  public_network_enabled          = each.value.public_network_enabled
  managed_virtual_network_enabled = each.value.managed_virtual_network_enabled
  tags                            = local.tags
  dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [] : [lookup(each.value, "assign_identity", false)]
    content {
      type = "SystemAssigned"
    }
  }

  dynamic "github_configuration" {
    for_each = lookup(each.value, "github_configuration", [])
    content {
      account_name    = lookup(github_configuration.value, "account_name", null)
      branch_name     = lookup(github_configuration.value, "branch_name", null)
      git_url         = lookup(github_configuration.value, "git_url", null)
      repository_name = lookup(github_configuration.value, "repository_name", null)
      root_folder     = lookup(github_configuration.value, "root_folder", null)
    }
  }
}

resource "azurerm_data_factory_integration_runtime_azure" "this" {
  for_each                = var.data_factory_integration_runtime_azure
  name                    = each.value["name"]
  data_factory_id         = local.adf_map[each.value.data_factory_name]
  location                = each.value["location"]
  compute_type            = each.value["compute_type"]
  core_count              = each.value["core_count"]
  time_to_live_min        = each.value["ttl"]
  virtual_network_enabled = true
  depends_on              = [azurerm_data_factory.this]
}