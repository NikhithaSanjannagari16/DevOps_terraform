data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  location            = module.globals.location
  name                = "wu2-${module.globals.environment}-vault01"
  resource_group_name = module.globals.resource_group

  tenant_id                       = module.globals.tenant_id
  enabled_for_template_deployment = true
  sku_name                        = "premium"
 # soft_delete_enabled             = true
  enabled_for_disk_encryption     = true
  tags = merge(module.globals.default_tags)
}

//add myself to allow vault ops
resource "azurerm_key_vault_access_policy" "self" {
  key_vault_id = azurerm_key_vault.vault.id
  object_id    = data.azurerm_client_config.current.object_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge",
    "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
  secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  certificate_permissions = ["Get"]
}

# data "azuread_service_principal" "app_service" {
#   display_name = "Microsoft Azure App Service"
# }

# resource "azurerm_key_vault_access_policy" "app_service" {
#   key_vault_id            = azurerm_key_vault.vault.id
#   object_id               = data.azuread_service_principal.app_service.id
#   tenant_id               = module.globals.tenant_id
#   secret_permissions      = ["Get"]
#   certificate_permissions = ["Get"]
# }
