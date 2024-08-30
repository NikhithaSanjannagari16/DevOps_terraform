data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "currentconf" {
}

data "azurerm_resource_group" "rgname" {
  name = module.globals.resource_group
}

resource "azurerm_role_assignment" "contributorexample" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.currentconf.object_id
}

####Resource group level 
resource "azurerm_role_assignment" "rgexample" {
  scope                = data.azurerm_resource_group.rgname.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.currentconf.object_id
}

################management group

data "azurerm_management_group" "parentMG" {
  name =  module.globals.parentMG_name
}

resource "azurerm_role_definition" "example1" {
  name               = "my-custom-role-definition"
  scope              = data.azurerm_subscription.primary.id

  permissions {
    actions     = ["Microsoft.Resources/subscriptions/resourceGroups/read"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

resource "azurerm_role_assignment" "example1" {
  scope              = data.azurerm_management_group.parentMG.id
  role_definition_id = azurerm_role_definition.example1.role_definition_resource_id
  principal_id       = data.azurerm_client_config.currentconf.object_id
}