resource "azurerm_subnet" "gateway_subnet" {
  name                                           = "GatewaySubnet"
  resource_group_name                            = module.globals.resource_group
  virtual_network_name                           = "${module.globals.environment}-vnet"
  address_prefixes                               = [module.globals.gatewaysubnet_address]
  lifecycle {
    ignore_changes = [delegation]
  }
}


# Virtual Network Gateway
resource "azurerm_public_ip" "vpn-gateway1-pip" {
    name                = var.vpn_gateway_name
    location            = module.globals.location
    resource_group_name = module.globals.resource_group

    allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vnet-gateway" {
    name                = "hub-vpn-gateway1"
    location            = module.globals.location
    resource_group_name = module.globals.resource_group

    type     = "ExpressRoute"
    vpn_type = "RouteBased"

    active_active = false
    enable_bgp    = false
    sku           = "ErGw3AZ"  //https://docs.microsoft.com/en-us/azure/expressroute/expressroute-about-virtual-network-gateways#gwsku -- CHANGE IF REGION WITHOUT AZs

    ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn-gateway1-pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
    }
    depends_on = [azurerm_public_ip.vpn-gateway1-pip]
}

data "azurerm_express_route_circuit" "expressRoute1" {
  resource_group_name = module.globals.resource_group
  name                = "expressRoute1"
}
resource "azurerm_virtual_network_gateway_connection" "local" {
  name                = "ER-Gateway-Connect"
  location            = module.globals.location
  resource_group_name = module.globals.resource_group

  type                       = "ExpressRoute"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vnet-gateway.id
  authorization_key          = "key1"
  express_route_circuit_id   = data.azurerm_express_route_circuit.expressRoute1.id
}