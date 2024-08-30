resource "azurerm_recovery_services_vault" "recoveryservice_vault" {
  name                = module.globals.recovery_service_vaultname
  location            = module.globals.location
  resource_group_name = module.globals.resource_group
  sku                 = "Standard"
}

resource "azurerm_backup_policy_vm" "example" {
  name                = module.globals.recovery_vault_policy_name
  resource_group_name = module.globals.resource_group
  recovery_vault_name = module.globals.recovery_service_vaultname

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 10
  }

  retention_weekly {
    count    = 42
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }

  retention_monthly {
    count    = 7
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }

  retention_yearly {
    count    = 77
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
}

# data "azurerm_recovery_services_vault" "vault" {
#   name                = module.globals.recovery_service_vaultname
#   resource_group_name = module.globals.resource_group
# }