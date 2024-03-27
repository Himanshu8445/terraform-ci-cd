data "azurerm_resource_group" "this" {
  name = var.resource_group_name_la
}

data "azurerm_resource_group" "str" {
  name = var.resource_group_name_str
}


data "azurerm_storage_account" "this" {
  name                = var.law_linked_strg_name
  resource_group_name = data.azurerm_resource_group.str.name
}

locals {
  tags = merge(var.law_additional_tags, data.azurerm_resource_group.this.tags)
}

# -
# - Create Log Analytics Workspace
# -
resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  sku                 = var.sku
  retention_in_days   = var.retention_in_days

  tags = local.tags

  lifecycle {
    ignore_changes = [
      location
    ]
  }
}

# -
# - Install the VMInsights solution
# -
resource "azurerm_log_analytics_solution" "this" {
  solution_name         = "VMInsights"
  resource_group_name   = data.azurerm_resource_group.this.name
  location              = data.azurerm_resource_group.this.location
  workspace_name        = azurerm_log_analytics_workspace.this.name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
  tags = local.tags
  lifecycle {
    ignore_changes = [
      location,
      workspace_resource_id,
      resource_group_name
    ]
  }
}

# - Link LAW with storage account

resource "azurerm_log_analytics_linked_storage_account" "this" {
  data_source_type      = "CustomLogs"
  resource_group_name   = data.azurerm_resource_group.this.name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  storage_account_ids   = [data.azurerm_storage_account.this.id]
}

