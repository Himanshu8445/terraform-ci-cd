
data "azurerm_resource_group" "this" {
  name = var.resource_group_name_vm
}

/* data "azurerm_storage_account" "this" {
  name                = var.diagnostics_sa_name
  resource_group_name = var.storage_resource_group
} */

/*data "azurerm_subnet" "this" {
 for_each             = local.networking_state_exists == false ? var.windows_vm_nics : {}
 name                 = each.value.subnet_name
 virtual_network_name = each.value.vnet_name
 resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.name)
}*/

data "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  resource_group_name = var.Keyvault_resource_group
}
data "azurerm_backup_policy_vm" "this" {
  for_each            = local.windows_vms_for_backup
  name                = each.value.vm_backup_policy_name
  recovery_vault_name = each.value.recovery_services_vault_name
  resource_group_name = data.azurerm_resource_group.this.name
}

# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}

locals {
  tags                       = var.vm_additional_tags
  /* resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  storage_state_exists       = length(values(data.terraform_remote_state.storage.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true
  keyvault_state_exists      = length(values(data.terraform_remote_state.keyvault.outputs)) == 0 ? false : true
  rsv_state_exists           = length(values(data.terraform_remote_state.recoveryservicesvault.outputs)) == 0 ? false : true */
  des_exists                 = { for k, v in var.windows_vms : k => v if lookup(v, "use_existing_disk_encryption_set", false) == true }
  key_permissions            = ["Get", "WrapKey", "UnwrapKey"]
  secret_permissions         = ["Get", "Set", "List"]
  certificate_permissions    = ["Get", "Create", "Update", "List", "Import"]
  storage_permissions        = ["Get"]
  windows_image_ids = {
    "jstartwinvm001" = null
  }
}

#
# Existing DES
#
data "azurerm_disk_encryption_set" "this" {
  for_each            = local.des_exists
  name                = lookup(each.value, "existing_disk_encryption_set_name", null)
  resource_group_name = lookup(each.value, "existing_disk_encryption_set_rg_name", null)
}


# -
# - Generate Password for Windows Virtual Machine
# -
resource "random_password" "this" {
  for_each         = var.windows_vms
  length           = 32
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  numeric          = true
  special          = true
  override_special = "!@#$%&"
}

# -
# - Store Generated Password to Key Vault Secrets
# -
resource "azurerm_key_vault_secret" "this" {
  for_each = var.windows_vms
  name     = each.value["name"]
  value    = lookup(random_password.this, each.key)["result"]
  #key_vault_id = data.azurerm_key_vault.this.id
  key_vault_id = var.key_vault_id

  lifecycle {
    ignore_changes = [value]
  }
}

#
#- Availability Set
#
resource "azurerm_availability_set" "this" {
  for_each                     = var.availability_sets
  name                         = each.value["name"]
  location                     = data.azurerm_resource_group.this.location
  resource_group_name          = data.azurerm_resource_group.this.name
  platform_update_domain_count = coalesce(lookup(each.value, "platform_update_domain_count"), 5)
  platform_fault_domain_count  = coalesce(lookup(each.value, "platform_fault_domain_count"), 3)
}

# -
# - Windows Virtual Machine
# -
resource "azurerm_windows_virtual_machine" "windows_vms" {
  for_each              = var.windows_vms
  name                  = each.value["name"]
  location              = data.azurerm_resource_group.this.location
  resource_group_name   = data.azurerm_resource_group.this.name
  network_interface_ids = [for nic_k, nic_v in azurerm_network_interface.windows_nics : nic_v.id if(contains(each.value["vm_nic_keys"], nic_k) == true)]
  size                  = coalesce(lookup(each.value, "vm_size"), "Standard_DS1_v2")
  zone                  = lookup(each.value, "availability_set_key", null) == null ? lookup(each.value, "zone", null) : null
  availability_set_id   = lookup(each.value, "availability_set_key", null) == null ? null : lookup(azurerm_availability_set.this, each.value["availability_set_key"])["id"]
  admin_username        = var.win_administrator_user_name
  admin_password        = lookup(random_password.this, each.key)["result"]

  os_disk {
    name                      = each.value["os_disk_name"]
    caching                   = coalesce(lookup(each.value, "storage_os_disk_caching"), "ReadWrite")
    storage_account_type      = coalesce(lookup(each.value, "managed_disk_type"), "Standard_LRS")
    disk_size_gb              = lookup(each.value, "disk_size_gb", null)
    write_accelerator_enabled = lookup(each.value, "write_accelerator_enabled", null)
    disk_encryption_set_id    = lookup(each.value, "use_existing_disk_encryption_set", false) == true ? lookup(data.azurerm_disk_encryption_set.this, each.key)["id"] : null
  }

  dynamic "source_image_reference" {
    for_each = lookup(local.windows_image_ids, each.value["name"], null) == null ? (lookup(each.value, "source_image_reference_publisher", null) == null ? [] : [lookup(each.value, "source_image_reference_publisher", null)]) : []
    content {
      publisher = lookup(each.value, "source_image_reference_publisher", null)
      offer     = lookup(each.value, "source_image_reference_offer", null)
      sku       = lookup(each.value, "source_image_reference_sku", null)
      version   = lookup(each.value, "source_image_reference_version", null)
    }
  }

  enable_automatic_updates = lookup(each.value, "enable_automatic_updates", null)
  computer_name            = upper(each.value["computer_name"])
  custom_data              = lookup(each.value, "custom_data_path", null) == null ? null : (base64encode(templatefile("${path.root}${each.value["custom_data_path"]}", each.value["custom_data_args"] != null ? each.value["custom_data_args"] : {})))
  source_image_id          = lookup(local.windows_image_ids, each.value["name"], null)

  /* boot_diagnostics {
    storage_account_uri = data.azurerm_storage_account.this.primary_blob_endpoint
  } */
  dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [] : tolist([coalesce(lookup(each.value, "assign_identity"), false)])
    content {
      type = "SystemAssigned"
    }
  }

  lifecycle {
    ignore_changes = [
      admin_password,
      network_interface_ids,
      os_disk[0].disk_encryption_set_id
    ]
  }

  tags = local.tags

  depends_on = [azurerm_disk_encryption_set.this, azurerm_key_vault_access_policy.cmk]
}

# -
# - Windows Network Interfaces
# -
resource "azurerm_network_interface" "windows_nics" {
  for_each                      = var.windows_vm_nics
  name                          = each.value.name
  location                      = data.azurerm_resource_group.this.location
  resource_group_name           = data.azurerm_resource_group.this.name
  internal_dns_name_label       = lookup(each.value, "internal_dns_name_label", null)
  enable_ip_forwarding          = lookup(each.value, "enable_ip_forwarding", null)
  enable_accelerated_networking = lookup(each.value, "enable_accelerated_networking", null)
  dns_servers                   = lookup(each.value, "dns_servers", null)

  dynamic "ip_configuration" {
    for_each = coalesce(each.value.nic_ip_configurations, [])
    content {
      name                          = coalesce(ip_configuration.value.name, format("%s00%d-ip", each.value.name, index(each.value.nic_ip_configurations, ip_configuration.value) + 1))
      subnet_id                     = each.value.subnet_id
      private_ip_address_allocation = lookup(ip_configuration.value, "static_ip", null) == null ? "Dynamic" : "Static"
      private_ip_address            = lookup(ip_configuration.value, "static_ip", null)
      primary                       = index(each.value.nic_ip_configurations, ip_configuration.value) == 0 ? true : false
    }
  }
  tags = local.tags
}
# -
# - Create Key Vault Accesss Policy for VM MSI
# -
locals {
  vm_ids_map = {
    for vm in azurerm_windows_virtual_machine.windows_vms :
    vm.name => vm.id
  }

  msi_enabled_windows_vms = [
    for vm_k, vm_v in var.windows_vms :
    vm_v if coalesce(lookup(vm_v, "assign_identity"), false) == true
  ]

  vm_principal_ids = flatten([
    for x in azurerm_windows_virtual_machine.windows_vms :
    [
      for y in x.identity :
      y.principal_id if y.principal_id != ""
    ] if length(keys(azurerm_windows_virtual_machine.windows_vms)) > 0
  ])
}

resource "azurerm_key_vault_access_policy" "this" {
  count = length(local.msi_enabled_windows_vms)
  #key_vault_id = data.azurerm_key_vault.this.id
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = element(local.vm_principal_ids, count.index)

  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions

  depends_on = [azurerm_windows_virtual_machine.windows_vms]
}

# -
# - Azure Backup for an Windows Virtual Machine
# -
locals {
  windows_vms_for_backup = {
    for vm_k, vm_v in var.windows_vms :
    vm_k => vm_v if vm_v.recovery_services_vault_name != null
  }
}

resource "azurerm_backup_protected_vm" "this" {
  for_each            = length(values(local.windows_vms_for_backup)) > 0 ? local.windows_vms_for_backup : {}
  resource_group_name = data.azurerm_resource_group.this.name
  recovery_vault_name = each.value["recovery_services_vault_name"]
  source_vm_id        = azurerm_windows_virtual_machine.windows_vms[each.key].id
  backup_policy_id    = lookup(data.azurerm_backup_policy_vm.this, each.key)["id"]
  depends_on          = [azurerm_windows_virtual_machine.windows_vms]
}

#########################################################
# Windows VM Managed Disk and VM & Managed Disk Attachment
#########################################################
locals {
  windows_vms = {
    for vm_k, vm_v in var.windows_vms :
    vm_k => {
      enable_cmk_disk_encryption = coalesce(vm_v.enable_cmk_disk_encryption, false) && (data.azurerm_key_vault.this.purge_protection_enabled == true)
      zone                       = vm_v.zone
      availability_set_key       = vm_v.availability_set_key
    }
  }
}

# -
# - Managed Disk
# -
resource "azurerm_managed_disk" "this" {
  for_each            = var.managed_data_disks
  name                = lookup(each.value, "disk_name", null) == null ? "${azurerm_windows_virtual_machine.windows_vms[each.value["vm_key"]]["name"]}-datadisk-${each.value["lun"]}" : each.value["disk_name"]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  #zones              = lookup(lookup(local.windows_vms, each.value["vm_key"]), "availability_set_key", null) == null ? (lookup(lookup(local.windows_vms, each.value["vm_key"]), "zone", null) != null ? tolist(lookup(lookup(local.windows_vms, each.value["vm_key"]), "zone")) : null) : null
  storage_account_type   = coalesce(lookup(each.value, "storage_account_type"), "Standard_LRS")
  disk_encryption_set_id = lookup(lookup(local.windows_vms, each.value["vm_key"]), "use_existing_disk_encryption_set", false) == true ? lookup(data.azurerm_disk_encryption_set.this, each.key)["id"] : lookup(lookup(local.windows_vms, each.value["vm_key"]), "enable_cmk_disk_encryption") == true && (data.azurerm_key_vault.this.purge_protection_enabled == true) ? lookup(azurerm_disk_encryption_set.this, each.value["vm_key"])["id"] : null
  disk_size_gb           = coalesce(lookup(each.value, "disk_size"), 1)
  os_type                = coalesce(lookup(each.value, "os_type"), "Windows")
  create_option          = coalesce(lookup(each.value, "create_option"), "Empty")
  source_resource_id     = coalesce(lookup(each.value, "create_option"), "Empty") == "Copy" ? each.value.source_resource_id : null

  tags = local.tags

  lifecycle {
    ignore_changes = [disk_encryption_set_id]
  }
  depends_on = [azurerm_windows_virtual_machine.windows_vms, azurerm_disk_encryption_set.this, azurerm_key_vault_access_policy.cmk]
}

# -
# - Windows VM - Managed Disk Attachment
# -
resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each                  = var.managed_data_disks
  managed_disk_id           = lookup(lookup(azurerm_managed_disk.this, each.key), "id", null)
  virtual_machine_id        = azurerm_windows_virtual_machine.windows_vms[each.value["vm_key"]]["id"]
  lun                       = coalesce(lookup(each.value, "lun"), "10")
  caching                   = coalesce(lookup(each.value, "caching"), "ReadWrite")
  write_accelerator_enabled = lookup(each.value, "write_accelerator_enabled", null)
  depends_on                = [azurerm_managed_disk.this, azurerm_windows_virtual_machine.windows_vms]
}

#####################################################
# Windows VM CMK and Disk Encryption Set
#####################################################
locals {
  cmk_enabled_virtual_machines = {
    for vm_k, vm_v in var.windows_vms :
    vm_k => vm_v if coalesce(lookup(vm_v, "enable_cmk_disk_encryption"), false) == true && (data.azurerm_key_vault.this.purge_protection_enabled == true)
  }
}

# -
# - Generate CMK Key for Windows VM
# -
resource "azurerm_key_vault_key" "this" {
  for_each = local.cmk_enabled_virtual_machines
  name     = each.value.customer_managed_key_name != null ? each.value.customer_managed_key_name : format("%s00%d-key", each.value.name, index(keys(local.cmk_enabled_virtual_machines), each.key) + 1)
  #key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.id
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt", "encrypt", "sign",
    "unwrapKey", "verify", "wrapKey"
  ]
}

# -
# - Enable Disk Encryption Set for Windows VM using CMK
# -
resource "azurerm_disk_encryption_set" "this" {
  for_each            = local.cmk_enabled_virtual_machines
  name                = each.value.disk_encryption_set_name != null ? each.value.disk_encryption_set_name : format("%s00%d", each.value.name, index(keys(local.cmk_enabled_virtual_machines), each.key) + 1)
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  key_vault_key_id    = lookup(azurerm_key_vault_key.this, each.key)["id"]

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [key_vault_key_id]
  }

  tags = local.tags
}

# -
# - Adding Access Policies for Disk Encryption Set MSI
# -
resource "azurerm_key_vault_access_policy" "cmk" {
  for_each = local.cmk_enabled_virtual_machines
  #key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.id
  key_vault_id = var.key_vault_id
  tenant_id    = lookup(azurerm_disk_encryption_set.this, each.key).identity.0.tenant_id
  object_id    = lookup(azurerm_disk_encryption_set.this, each.key).identity.0.principal_id

  key_permissions    = local.key_permissions
  secret_permissions = local.secret_permissions
}

######################################################
# Role Assignment
######################################################

# -
# - Assigning Reader Role to VM in order to access KV using MSI Identity
# -
resource "azurerm_role_assignment" "kv" {
  count = (var.kv_role_assignment == true && length(local.msi_enabled_windows_vms) > 0) ? length(local.vm_principal_ids) : 0
  #scope                            = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.id
  scope                            = var.key_vault_id
  role_definition_name             = "Reader"
  principal_id                     = element(local.vm_principal_ids, count.index)
  skip_service_principal_aad_check = true
}

# -
# - Assigning Reader Role to VM in order to access itself using MSI Identity
# -
resource "azurerm_role_assignment" "vm" {
  count                            = (var.self_role_assignment == true && length(local.msi_enabled_windows_vms) > 0) ? length(local.vm_principal_ids) : 0
  scope                            = lookup(local.vm_ids_map, element(local.msi_enabled_windows_vms, count.index)["name"])
  role_definition_name             = "Reader"
  principal_id                     = element(local.vm_principal_ids, count.index)
  skip_service_principal_aad_check = true
}
