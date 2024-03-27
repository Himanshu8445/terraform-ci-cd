# #############################################################################
# # OUTPUTS Linux VM
# #############################################################################

output "linux_vm_names" {
  value = [for x in azurerm_linux_virtual_machine.linux_vms : x.name]
}

output "linux_vm_private_ip_address" {
  value = [for x in azurerm_linux_virtual_machine.linux_vms : x.private_ip_address]
}