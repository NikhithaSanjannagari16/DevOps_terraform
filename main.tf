data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "pagerduty-kv" {
  name                            = lower("kv-${var.key_vault_name}")
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  soft_delete_retention_days      = var.soft_delete_retention_days
  enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = var.enable_purge_protection
  tags                            = merge({ "ResourceName" = lower("kv-${var.key_vault_name}") }, var.tags, )

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    virtual_network_subnet_ids = resource.azurerm_subnet.snet-pagerduty.*.id
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
  depends_on          = [azurerm_subnet.snet-pagerduty]
}

#---------------------------------------------------------
# Private Link for Keyvault
#---------------------------------------------------------
resource "azurerm_subnet" "snet-pagerduty" {
  name                                           = "snet-endpoint-${var.location}"
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = data.azurerm_virtual_network.vnet01.name
  address_prefixes                               = var.private_subnet_address_prefix
  enforce_private_link_endpoint_network_policies = true
  service_endpoints = ["Microsoft.KeyVault"]

  delegation {
      name = "delegation"

      service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
      }
  }
}

resource "azurerm_private_endpoint" "pep1" {
  name                = format("%s-private-endpoint", var.key_vault_name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.snet-pagerduty.id
  tags                = merge({ "Name" = format("%s-private-endpoint", var.key_vault_name) }, var.tags, )

  private_service_connection {
    name                           = "keyvault-privatelink"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.pagerduty-kv.id
    subresource_names              = ["vault"]
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

data "azurerm_private_endpoint_connection" "private-ip1" {
  name                = azurerm_private_endpoint.pep1.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_key_vault.pagerduty-kv]
}

resource "azurerm_private_dns_zone" "dnszone1" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
  tags                = merge({ "Name" = format("%s", "KeyVault-Private-DNS-Zone") }, var.tags, )
}

resource "azurerm_private_dns_zone_virtual_network_link" "vent-link1" {
  name                  = "vnet-private-zone-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dnszone1.name
  virtual_network_id    = data.azurerm_virtual_network.vnet01.id
  registration_enabled  = true
  tags                  = merge({ "Name" = format("%s", "vnet-private-zone-link") }, var.tags, )

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_private_dns_a_record" "arecord1" {
  name                = azurerm_key_vault.pagerduty-kv
  zone_name           = azurerm_private_dns_zone.dnszone1.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.private-ip1.private_service_connection.private_ip_address]
}