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

output "key-vault" {
  value     = module.key-vault
  sensitive = true
}

output "loganalytics" {
  value     = module.loganalytics
  sensitive = true
}