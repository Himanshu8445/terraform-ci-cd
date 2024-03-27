output "resourcegroup" {
  value     = module.resourcegroup
  sensitive = true
}

output "storage_acct" {
  value     = module.storage_acct
  sensitive = true
}

output "vnet" {
  value     = module.vnet
  sensitive = true
}

output "nsg" {
  value     = module.nsg
  sensitive = true
}

output "route_table" {
  value     = module.route_table
  sensitive = true
}

output "datafactory" {
  value     = module.datafactory
  sensitive = true
}

output "databricks-workspace" {
  value     = module.databricks-workspace
  sensitive = true
}

output "key-vault" {
  value     = module.key-vault
  sensitive = true
}