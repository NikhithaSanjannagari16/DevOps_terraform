output "nic_id" {
  value =  azurerm_network_interface.linuxnic.id
}

output "linux_vm_name" {
  value =  azurerm_linux_virtual_machine.linuxvm.name
}