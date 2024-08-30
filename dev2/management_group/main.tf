data "azurerm_subscription" "current" {
}

resource "azurerm_management_group" "parentMG" {
  display_name = var.parent_management_group

  subscription_ids = [
    data.azurerm_subscription.current.subscription_id
  ]
}

resource "azurerm_management_group" "childMG" {
  display_name               = var.child_management_group
  parent_management_group_id = azurerm_management_group.parentMG.id

  subscription_ids = [
    data.azurerm_subscription.current.subscription_id,
  ]
  # other subscription IDs can go here
}

resource "azurerm_management_group_subscription_association" "example" {
  management_group_id = azurerm_management_group.parentMG.id
  subscription_id     = data.azurerm_subscription.current.id
}