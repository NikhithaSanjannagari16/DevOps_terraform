resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  location            = module.globals.location
  resource_group_name = module.globals.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb1" {
  name                = var.load_balancer_name
  location            = module.globals.location
  resource_group_name = module.globals.resource_group
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}
data "azurerm_virtual_network" "vnet1" {
  name                =  "${module.globals.environment}-vnet"
  resource_group_name = module.globals.resource_group
}

data "azurerm_network_interface" "linuxnic" {
  name                = "wu2-dev-nic01"
  resource_group_name = module.globals.resource_group
}
data "azurerm_network_interface" "windowsnic" {
  name                = "wu2-dev-windows-vm-nic01"
  resource_group_name = module.globals.resource_group
}
resource "azurerm_lb_backend_address_pool" "lb1pool" {
  loadbalancer_id = azurerm_lb.lb1.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool" "lb2pool" {
  name            = "BackEndAddressPool-2"
  loadbalancer_id = azurerm_lb.lb1.id
}

resource "azurerm_lb_backend_address_pool_address" "backend" {
  name                    = "linux-vm"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb1pool.id
  virtual_network_id      = data.azurerm_virtual_network.vnet1.id
  ip_address              = data.azurerm_network_interface.linuxnic.private_ip_address //specify the backend resource ip address
}
resource "azurerm_lb_backend_address_pool_address" "backend2" {
  name                    = "windows-vm"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb2pool.id
  virtual_network_id      = data.azurerm_virtual_network.vnet1.id
  ip_address              = data.azurerm_network_interface.windowsnic.private_ip_address //specify the backend resource ip address
}

# resource "azurerm_lb_nat_pool" "lb1natpool" {
#   resource_group_name            = module.globals.resource_group
#   loadbalancer_id                = azurerm_lb.lb1.id
#   name                           = "SampleApplicationPool"
#   protocol                       = "Tcp"
#   frontend_port_start            = 80
#   frontend_port_end              = 81
#   backend_port                   = 8080
#   frontend_ip_configuration_name = "PublicIPAddress"
# }

# resource "azurerm_lb_nat_rule" "example1" {
#   resource_group_name            = module.globals.resource_group
#   loadbalancer_id                = azurerm_lb.lb1.id
#   name                           = "RDPAccess"
#   protocol                       = "Tcp"
#   frontend_port_start            = 3000
#   frontend_port_end              = 3389
#   backend_port                   = 3389
#   backend_address_pool_id        = azurerm_lb_backend_address_pool.lb1pool.id
#   frontend_ip_configuration_name = "PublicIPAddress"
# }

# resource "azurerm_lb_outbound_rule" "lb1outbound" {
#   name                    = "OutboundRule"
#   loadbalancer_id         = azurerm_lb.lb1.id
#   protocol                = "Tcp"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.lb1pool.id

#   frontend_ip_configuration {
#     name = "PublicIPAddress"
#   }
# }

resource "azurerm_lb_probe" "lb1probe" {
  loadbalancer_id = azurerm_lb.lb1.id
  name            = "ssh-running-probe"
  port            = 22
}

resource "azurerm_lb_rule" "lb1rule" {
  loadbalancer_id                = azurerm_lb.lb1.id
  name                           = "LBRule1"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.lb1probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb1pool.id]
}

resource "azurerm_lb_rule" "lb2rule" {
  loadbalancer_id                = azurerm_lb.lb1.id
  name                           = "LBRule2"
  protocol                       = "Tcp"
  frontend_port                  = 8081
  backend_port                   = 8081
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.lb1probe.id
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.lb2pool.id]
}
