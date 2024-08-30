resource "azurerm_storage_account" "to_monitor" {
  name                     = var.storage_account_to_montior
  resource_group_name      = module.globals.resource_group
  location                 = module.globals.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_action_group" "main" {
  name                = var.action_group_name
  resource_group_name = module.globals.resource_group
  short_name          = "ag1"

  webhook_receiver {
    name        = "callmyapi"
    service_uri = "https://w2stabiltest1.blob.core.windows.net/"  //change based on the requirement
   }
}

resource "azurerm_monitor_metric_alert" "alert1" {
  name                = var.alert_name
  resource_group_name = module.globals.resource_group
  scopes              = [azurerm_storage_account.to_monitor.id]
  description         = "Action will be triggered when Transactions count is greater than 50."

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "Transactions"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50

    dimension {
      name     = "ApiName"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}