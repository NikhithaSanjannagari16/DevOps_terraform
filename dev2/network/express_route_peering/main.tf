resource "azurerm_express_route_circuit" "expressRoute1" {
  name                  = "expressRoute1"
  resource_group_name   = module.globals.resource_group
  location              = module.globals.location
  service_provider_name = "Equinix"
  peering_location      = "Silicon Valley"
  bandwidth_in_mbps     = 50

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  allow_classic_operations = false

  tags = {
    environment = "Production"
  }
}

resource "azurerm_express_route_circuit_peering" "expressRoute1_peering" {
  peering_type                  = "MicrosoftPeering"
  express_route_circuit_name    = azurerm_express_route_circuit.expressRoute1.name
  resource_group_name           = module.globals.resource_group
  peer_asn                      = 100
  primary_peer_address_prefix   = "123.0.0.0/30"
  secondary_peer_address_prefix = "123.0.0.4/30"
  vlan_id                       = 300

  microsoft_peering_config {
    advertised_public_prefixes = ["123.1.0.0/24"]
  }

  ipv6 {
    primary_peer_address_prefix   = "2002:db01::/126"
    secondary_peer_address_prefix = "2003:db01::/126"

    microsoft_peering {
      advertised_public_prefixes = ["2002:db01::/126"]
    }
  }
}
resource "azurerm_express_route_circuit_peering" "azureprivate_peering" {
  peering_type                  = "AzurePrivatePeering"
  express_route_circuit_name    = azurerm_express_route_circuit.expressRoute1.name
  resource_group_name           = module.globals.resource_group
  #shared_key                    = "key1" //enter shared key
  peer_asn                      = 100
  primary_peer_address_prefix   = "192.168.1.0/30"
  secondary_peer_address_prefix = "192.168.2.0/30"
  vlan_id                       = 100
}

resource "azurerm_express_route_circuit_authorization" "auth" {
  name                       = "exampleERCAuth"
  express_route_circuit_name = azurerm_express_route_circuit.expressRoute1.name
  resource_group_name        = module.globals.resource_group
}
