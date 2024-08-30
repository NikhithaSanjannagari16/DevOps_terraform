data "azurerm_subnet" "subnet1" {
  name                 =  "${module.globals.environment}-${module.globals.linuxvm_subnet_name}"
  virtual_network_name =  "${module.globals.environment}-vnet"
  resource_group_name  = module.globals.resource_group
} 

data "azurerm_subnet" "subnet2" {
  name                 =  "${module.globals.environment}-${module.globals.windows-vm-subnet_name}"
  virtual_network_name =  "${module.globals.environment}-vnet"
  resource_group_name  = module.globals.resource_group
} 

data "azurerm_network_security_group" "nsg1" {
  name                = "${module.globals.environment}-nsg1"
  resource_group_name =  module.globals.resource_group
}
data "azurerm_network_security_group" "nsg2" {
  name                = "${module.globals.environment}-nsg2"
  resource_group_name =  module.globals.resource_group
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  #for_each                  = local.ASE_envs
  #count = length(data.azurerm_subnet.subnets)
  network_security_group_id = data.azurerm_network_security_group.nsg1.id
  subnet_id                 = data.azurerm_subnet.subnet1.id
}
resource "azurerm_subnet_network_security_group_association" "winvmassoc" {
  #for_each                  = local.ASE_envs
  #count = length(data.azurerm_subnet.subnets)
  network_security_group_id = data.azurerm_network_security_group.nsg2.id
  subnet_id                 = data.azurerm_subnet.subnet2.id
}
