module "resourcegroup" {
  source          = "../modules/resourcegroup"
  resource_groups = var.resource_groups
}

module "vnet" {
  source                      = "../modules/networking"
  resource_group_name_network = var.resource_group_name_network
  virtual_networks            = var.virtual_networks
  subnets                     = var.subnets
  vnet_tags                   = var.vnet_tags
  depends_on                  = [module.resourcegroup]
}

module "nsg" {
  source                  = "../modules/networksecuritygroup"
  network_security_groups = var.network_security_groups
  nsg_additional_tags     = var.nsg_additional_tags
  nsg_subnet_association  = var.nsg_subnet_association
  depends_on              = [module.vnet]
}

module "route_table" {
  source                      = "../modules/routetable"
  resource_group_name_network = var.resource_group_name_network
  route_tables                = var.route_tables
  route_table_tags            = var.route_table_tags
  depends_on                  = [module.vnet]
}

module "key-vault" {
  source             = "../modules/keyvault"
  keyvaults          = var.keyvaults
  kv_additional_tags = var.kv_additional_tags
  access_policies    = var.access_policies
  secrets            = var.secrets
  depends_on         = [module.resourcegroup]
}

module "linuxvm" {
  source                  = "../modules/linuxvirtualmachine"
  linux_vms               = var.linux_vms
  resource_group_name_vm  = var.resource_group_name_vm
  key_vault_name          = var.key_vault_name
  administrator_user_name = var.administrator_user_name
  linux_vm_nics           = var.linux_vm_nics
  managed_data_disks      = var.managed_data_disks
  Keyvault_resource_group = var.Keyvault_resource_group
}

module "storage_acct" {
  source             = "../modules/storageaccount"
  storage_accounts   = var.storage_accounts
  containers         = var.containers
  sa_additional_tags = var.sa_additional_tags
  depends_on         = [module.resourcegroup]
}

module "loganalytics" {
  source                  = "../modules/loganalytics"
  resource_group_name_la  = var.resource_group_name_la
  resource_group_name_str = var.resource_group_name_str
  name                    = var.name
  sku                     = var.sku
  retention_in_days       = var.retention_in_days
  law_additional_tags     = var.law_additional_tags
  law_linked_strg_name    = var.law_linked_strg_name
  depends_on = [
    module.storage_acct
  ]
}

module "purview_account" {
  source          = "../modules/purviewaccount"
  purview_account = var.purview_account
  depends_on      = [module.resourcegroup]
}