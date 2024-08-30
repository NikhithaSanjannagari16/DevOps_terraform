output "nic_id" {
  value =  azurerm_network_interface.winnic.id
}

output "windows_vm_name" {
  value =  azurerm_windows_virtual_machine.winvm.name
}