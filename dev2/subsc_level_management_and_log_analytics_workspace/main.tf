data "azurerm_subscription" "current" {
}

# resource "azurerm_security_center_setting" "example" {
#   setting_name = "MCAS" //WDTAP is apther setting name
#   enabled      = true
# }

resource "azurerm_security_center_auto_provisioning" "example" {
  auto_provision = "On"
}

resource "azurerm_security_center_subscription_pricing" "example" {
  tier          = "Standard" // free and standard tiers are available
  resource_type = "VirtualMachines"
}

resource "azurerm_log_analytics_workspace" "law1" {
  name                = var.security_workspace_name
  location            = module.globals.location
  resource_group_name = module.globals.resource_group
  sku                 = "PerGB2018"
}

resource "azurerm_security_center_workspace" "workspace1" {
  scope        = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
  workspace_id = azurerm_log_analytics_workspace.law1.id
}