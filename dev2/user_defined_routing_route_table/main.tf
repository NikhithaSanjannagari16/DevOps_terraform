resource "azurerm_route_table" "routetable1" {
  name                          = "wu2-${module.globals.environment}-routetable"
  location                      = module.globals.location
  resource_group_name           = module.globals.resource_group
  disable_bgp_route_propagation = false
}
resource "azurerm_route" "route1" {
  name                = var.route1_name
  resource_group_name = module.globals.resource_group
  route_table_name    = azurerm_route_table.routetable1.name
  address_prefix      = var.route1_address_prefix
  next_hop_type       = var.hop_type
}

data "azurerm_subnet" "subnetname" {
  name                 = "${module.globals.environment}-${module.globals.linuxvm_subnet_name}"
  virtual_network_name = "${module.globals.environment}-vnet"
  resource_group_name  = module.globals.resource_group
}
data "azurerm_subnet" "subnetname1" {
  name                 = "${module.globals.environment}-${module.globals.windows-vm-subnet_name}"
  virtual_network_name = "${module.globals.environment}-vnet"
  resource_group_name  = module.globals.resource_group
}

resource "azurerm_subnet_route_table_association" "subnetassoc" {
  subnet_id      = data.azurerm_subnet.subnetname.id
  route_table_id = azurerm_route_table.routetable1.id
}
resource "azurerm_subnet_route_table_association" "subnetassoc1" {
  subnet_id      = data.azurerm_subnet.subnetname1.id
  route_table_id = azurerm_route_table.routetable1.id
}