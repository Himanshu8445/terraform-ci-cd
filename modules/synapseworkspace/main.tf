data "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group
}

data "azurerm_storage_account" "this" {
  name                = var.synstorageaccountname
  resource_group_name = var.storage_resource_group
}

# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}

locals {
  tags = var.syn_additional_tags
}

# Generate random password
resource "random_password" "this" {
  length           = 32
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  numeric          = true
  special          = true
  override_special = "!@#$%&"
}

# -
# - Synapse Workspace
# -
resource "azurerm_synapse_workspace" "this" {
  for_each                             = var.synapse_workspaces
  name                                 = each.value["name"]
  resource_group_name                  = each.value["resource_group_name"]
  location                             = each.value["location"]
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.this.id
  sql_administrator_login              = each.value["SQLUsername"]
  sql_administrator_login_password     = random_password.this.result
  managed_resource_group_name          = each.value["mrgname"]
  managed_virtual_network_enabled      = each.value["managed_virtual_network_enabled"]
  public_network_access_enabled        = each.value["public_network_access_enabled"]
  data_exfiltration_protection_enabled = each.value["data_exfiltration_protection_enabled"]
  tags                                 = local.tags
  depends_on                           = [azurerm_storage_data_lake_gen2_filesystem.this]
  dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [] : [lookup(each.value, "assign_identity", false)]
    content {
      type = "SystemAssigned"
    }
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = var.adls2
  storage_account_id = data.azurerm_storage_account.this.id
}

# -
# - Upload the SQL admin password to Azure Keyvault
# -
resource "azurerm_key_vault_secret" "this" {
  for_each        = var.synapse_workspaces
  name            = "${each.value["name"]}-sqladmin-password"
  value           = random_password.this.result
  key_vault_id    = data.azurerm_key_vault.this.id
  expiration_date = var.expiration_date
  content_type    = var.content_type 
  depends_on      = [azurerm_synapse_workspace.this]
}

# -
# - Synapse Firewall rule to allow services from Azure
# -
/* resource "azurerm_synapse_firewall_rule" "synrule" {
  for_each             = var.synapse_workspaces
  name                 = "AllowAllWindowsAzureIps"
  synapse_workspace_id = azurerm_synapse_workspace.this[each.key].id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "0.0.0.0"
  depends_on           = [azurerm_synapse_workspace.this]
} */