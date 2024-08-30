# resource "azurerm_private_dns_zone" "zonename" {
#   name                = var.private_dns_zone_name
#   resource_group_name = module.globals.resource_group
# }

# resource "azurerm_private_dns_a_record" "dnsrecord" {
#   name                = "test"
#   zone_name           = azurerm_private_dns_zone.zonename.name
#   resource_group_name = module.globals.resource_group
#   ttl                 = 300
#   records             = ["10.0.180.17"] //change ip based on resource
# }

# resource "azurerm_private_dns_cname_record" "dnsrecordcname" {
#   name                = "testcname"
#   zone_name           = azurerm_private_dns_zone.zonename.name
#   resource_group_name = module.globals.resource_group
#   ttl                 = 300
#   record              = "contoso.com" //add record name
# }

resource "azurerm_private_dns_zone" "storagedns" {
  name                = var.private_dns_zone_name
  resource_group_name = module.globals.resource_group
}

data "azurerm_virtual_network" "vnet1" {
  name                =  "${module.globals.environment}-vnet"
  resource_group_name = module.globals.resource_group
}
data "azurerm_subnet" "pesubnet1" {
  name                 =  "${module.globals.environment}-${module.globals.pe_subnet_name}"
  virtual_network_name =  "${module.globals.environment}-vnet"
  resource_group_name  = module.globals.resource_group
} 
data "azurerm_storage_account" "storageaccount" {
  name                = module.globals.state_storage_account
  resource_group_name = module.globals.resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
  name                  = "vnet_link"
  resource_group_name   = module.globals.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.storagedns.name
  virtual_network_id    = data.azurerm_virtual_network.vnet1.id
}
resource "azurerm_private_endpoint" "endpoint" {
  name                = var.pe_name
  location            = module.globals.location
  resource_group_name = module.globals.resource_group
  subnet_id           = data.azurerm_subnet.pesubnet1.id

  private_service_connection {
    name                           = format("%s-%s", var.pe_name, "privateserviceconnection")
    private_connection_resource_id = data.azurerm_storage_account.storageaccount.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_dns_a_record" "dns_a" {
  name                = format("%s-%s", var.pe_name, "arecord")
  zone_name           = var.private_dns_zone_name
  resource_group_name = module.globals.resource_group
  ttl                 = 300
  records             = [azurerm_private_endpoint.endpoint.private_service_connection.0.private_ip_address]
}