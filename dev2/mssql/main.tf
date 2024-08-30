resource "random_password" "pwd" {
  length      = 22
  min_special = 2
  min_lower   = 2
  min_upper   = 2
  min_numeric = 2
}

resource "azurerm_mssql_server" "mysql" {
  name                = "wu2-${module.globals.environment}-db-server01"
  location            = module.globals.location
  resource_group_name = module.globals.resource_group
  administrator_login          = "dbadmin"
  administrator_login_password = random_password.pwd.result
  version    = "12.0"
  #backup_retention_days            = 7
  #geo_redundant_backup_enabled     = false
  public_network_access_enabled    = false
  #ssl_enforcement_enabled          = true
  #ssl_minimal_tls_version_enforced = "TLS1_2"
  #auto_grow_enabled                = true
  timeouts {
    create = "1h"
  }
  # lifecycle {
  #   ignore_changes = [ssl_enforcement_enabled,ssl_minimal_tls_version_enforced,threat_detection_policy]
  # }
}

resource "azurerm_mssql_database" "test" {
  name           = "wu2-dev-db01"
  server_id      = azurerm_mssql_server.mysql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  read_scale     = true
  sku_name       = "BC_Gen5_2"
  zone_redundant = true
  # short_term_retention_policy = {
  #  backup_retention_days = 7
  # }
  tags = merge(module.globals.default_tags)
}
data "azurerm_key_vault" "keyvault1" {
  resource_group_name = module.globals.resource_group
  name         = "wu2-${module.globals.environment}-vault01"
}

resource "azurerm_key_vault_secret" "db_pwd" {
  key_vault_id = data.azurerm_key_vault.keyvault1.id
  name         = "${module.globals.environment}-db-creds"
  value        = "user: dbadmin, pwd: ${random_password.pwd.result}"
  tags = merge(module.globals.default_tags)
}
