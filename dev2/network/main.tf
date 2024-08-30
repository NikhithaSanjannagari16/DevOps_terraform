resource "azurerm_virtual_network" "vnet" {
  name                = "${module.globals.environment}-vnet"
  location            = module.globals.location
  resource_group_name = module.globals.resource_group
  address_space       = [module.globals.vnet_cidr]
  tags = merge(module.globals.default_tags)
}

resource "azurerm_subnet" "subnets" {
  for_each                                       = module.globals.subnets
  name                                           = "${module.globals.environment}-${each.key}"
  resource_group_name                            = module.globals.resource_group
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [each.value]
  lifecycle {
    ignore_changes = [delegation]
  }
  enforce_private_link_endpoint_network_policies = true
}

module "nsg" {
  source = "./nsg" 
}
module "nsg_association" {
  source = "./nsg_association" 
}
module "vnet_peer" {
  source = "./vnet_peer"
}
module "express_route_peering" {
  source = "./express_route_peering"
}
module "virtual_network_gateway" {
   source = "./virtual_network_gateway"
}