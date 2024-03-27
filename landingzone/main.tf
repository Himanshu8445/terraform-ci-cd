module "resourcegroup" {
  source          = "../modules/resourcegroup"
  resource_groups = var.resource_groups
}

module "storage_acct" {
  source             = "../modules/storageaccount"
  storage_accounts   = var.storage_accounts
  containers         = var.containers
  sa_additional_tags = var.sa_additional_tags
  depends_on         = [module.resourcegroup]
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

module "datafactory" {
  source                                 = "../modules/datafactory"
  data_factory                           = var.data_factory
  adf_additional_tags                    = var.adf_additional_tags
  data_factory_integration_runtime_azure = var.data_factory_integration_runtime_azure
  depends_on                             = [module.resourcegroup]
}

module "datafactory_diag" {
  source                          = "../modules/diagnostics-settings/datafactory"
  diagnostic_settings_datafactory = var.diagnostic_settings_datafactory
  law_workspace_id                = var.law_workspace_id
  depends_on = [
    module.datafactory
  ]
}

module "databricks-workspace" {
  source                          = "../modules/databricks"
  databricks_workspaces           = var.databricks_workspaces
  network_security_groups_private = var.network_security_groups_private
  network_security_groups_public  = var.network_security_groups_public
  networking_resource_group       = var.networking_resource_group
  databricks_additional_tags      = var.databricks_additional_tags
  nsg_tags                        = var.nsg_tags
  depends_on                      = [module.resourcegroup]
}

module "data_bricks_diag" {
  source                         = "../modules/diagnostics-settings/databricks"
  diagnostic_settings_databricks = var.diagnostic_settings_databricks
  law_workspace_id               = var.law_workspace_id
  depends_on                     = [module.databricks-workspace]
}

module "key-vault" {
  source             = "../modules/keyvault"
  keyvaults          = var.keyvaults
  kv_additional_tags = var.kv_additional_tags
  access_policies    = var.access_policies
  secrets            = var.secrets
  depends_on         = [module.resourcegroup]
}

module "windows-vm" {
  source                      = "../modules/windowsvirtualmachine"
  windows_vms                 = var.windows_vms
  resource_group_name_vm      = var.resource_group_name_vm
  key_vault_name              = var.key_vault_name
  win_administrator_user_name = var.win_administrator_user_name
  windows_vm_nics             = var.windows_vm_nics
  managed_data_disks          = var.managed_data_disks
  key_vault_id                = var.key_vault_id
  Keyvault_resource_group     = var.Keyvault_resource_group
  vm_additional_tags          = var.vm_additional_tags
}

module "synapse-workspace" {
  source                   = "../modules/synapseworkspace"
  synapse_workspaces       = var.synapse_workspaces
  syn_additional_tags      = var.syn_additional_tags
  key_vault_name           = var.key_vault_name
  key_vault_resource_group = var.key_vault_resource_group
  expiration_date          = var.expiration_date
  content_type             = var.content_type
  adls2                    = var.adls2
  storage_resource_group   = var.storage_resource_group
  synstorageaccountname    = var.synstorageaccountname
  depends_on               = [module.storage_acct]
}