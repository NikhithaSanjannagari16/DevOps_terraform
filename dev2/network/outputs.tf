output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "resource_group_name" {
  value = module.globals.resource_group
}

output "location" {
  value = module.globals.location
}

output "subnet_id" {
  value = {
  for k, v in azurerm_subnet.subnets:
  k => v.id
  }
  //value = azurerm_subnet.subnets
}
