resource "azurerm_network_security_group" "nsg" {
  for_each            = local.ASE_envs
  location            = module.globals.location
  name                = "${module.globals.environment}-${each.value}"
  resource_group_name = module.globals.resource_group
  //INBOUND------------------------------
  security_rule {
    name                       = "Deny_All_In"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  //OUTBOUND------------------------------

  security_rule {
    name                       = "Deny_All_out"
    priority                   = 4000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = merge(module.globals.default_tags)
}

module "nsg_rules" {
  source = "./nsg_rules"
}

