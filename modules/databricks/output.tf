output "map_workspace_ids" {
  value = { for x in azurerm_databricks_workspace.databricks_ws : x.name => x.id }
}