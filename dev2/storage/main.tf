# data "azurerm_subnet" "subnet" {
#   name                 = module.globals.pe_subnet_name
#   virtual_network_name = "${module.globals.environment}-vnet"
#   resource_group_name  = module.globals.resource_group
# }
resource "azurerm_storage_account" "devinfra" {
  account_kind             = "StorageV2"
  access_tier              = "Hot"
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = module.globals.location
  name                     = module.globals.state_storage_account
  resource_group_name      = module.globals.resource_group
  tags = merge(module.globals.default_tags)
}

resource "azurerm_storage_container" "terraform_state" {
  name                 = module.globals.state_container_name
  storage_account_name = module.globals.state_storage_account
}

# resource "azurerm_private_endpoint" "example" {
#   name                = "${module.globals.environment}-pe"
#   resource_group_name      = module.globals.resource_group
#   location                 = module.globals.location
#   subnet_id           = data.azurerm_subnet.subnet.id

#   private_service_connection {
#     name                           = "{module.globals.environment}-psc"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_storage_account.devinfra.id
#     subresource_names              = ["blob"]
#   }
#   #private_dns_zone_group = module.globals.private_dns_zone_group_name
#   #private_dns_zone_ids = module.globals.private_dns_zone_ids
# }