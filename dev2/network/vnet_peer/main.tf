data "azurerm_virtual_network" "peer_network" {
  name                = var.peer_vnet_name
  resource_group_name = var.peer_vnet_resourcegroup
}

data "azurerm_virtual_network" "vnet1" {
  name                ="${module.globals.environment}-vnet"
  resource_group_name = module.globals.resource_group
}

resource "azurerm_virtual_network_peering" "vnet1" {
  name                      = "${module.globals.environment}-vnet-to-${var.peer_vnet_name}"
  resource_group_name       = module.globals.resource_group
  virtual_network_name      = "${module.globals.environment}-vnet"
  remote_virtual_network_id = data.azurerm_virtual_network.peer_network.id
}

resource "azurerm_virtual_network_peering" "vnet2" {
  name                      = "${var.peer_vnet_name}-to-${module.globals.environment}-vnet"
  resource_group_name       = module.globals.resource_group
  virtual_network_name      = var.peer_vnet_name
  remote_virtual_network_id = data.azurerm_virtual_network.vnet1.id
}