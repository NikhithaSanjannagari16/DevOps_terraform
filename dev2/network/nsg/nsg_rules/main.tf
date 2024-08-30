################# linux nsg rule (nsg1) #####################################################################

resource "azurerm_network_security_rule" "linux1" {
  name                        = "ALLOW_SSH"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "22"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = module.globals.resource_group
  network_security_group_name = var.linux_nsg
}

resource "azurerm_network_security_rule" "linux2" {
  name                        = "Allow_DNS"
  priority                    = 220
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "53"
  destination_port_range      = "*"
  source_address_prefix       = "10.2.14.10, 10.6.14.10, 10.5.14.10, 10.12.86.10, 10.16.171.10"
  destination_address_prefix  = "*"
  resource_group_name         = module.globals.resource_group
  network_security_group_name = var.linux_nsg
}

################# windows nsg rule (nsg2) #####################################################################
resource "azurerm_network_security_rule" "win1" {
  name                        = "Allow_RDP"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "3389"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = module.globals.resource_group
  network_security_group_name = var.windows_nsg
}

resource "azurerm_network_security_rule" "win2" {
  name                        = "Allow_DNS"
  priority                    = 220
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "53"
  destination_port_range      = "*"
  source_address_prefix       = "10.2.14.10, 10.6.14.10, 10.5.14.10, 10.12.86.10, 10.16.171.10"
  destination_address_prefix  = "*"
  resource_group_name         = module.globals.resource_group
  network_security_group_name = var.windows_nsg
}
################# hybrid nsg rule (nsg3) #####################################################################
resource "azurerm_network_security_rule" "hybrid1" {
  name                        = "Allow_RDP"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "3389"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = module.globals.resource_group
  network_security_group_name = var.hybrid_nsg
}

resource "azurerm_network_security_rule" "hybrid2" {
  name                        = "ALLOW_SSH"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "22"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = module.globals.resource_group
  network_security_group_name = var.hybrid_nsg
}

resource "azurerm_network_security_rule" "hybrid3" {
  name                        = "Allow_DNS"
  priority                    = 220
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "53"
  destination_port_range      = "*"
  source_address_prefix       = "10.2.14.10, 10.6.14.10, 10.5.14.10, 10.12.86.10, 10.16.171.10"
  destination_address_prefix  = "*"
  resource_group_name         = module.globals.resource_group
  network_security_group_name = var.hybrid_nsg
}
