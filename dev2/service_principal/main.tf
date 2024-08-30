data "azuread_client_config" "current" {}

resource "azuread_application" "azureadapp" {
  display_name = var.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "spn1" {
  application_id               = azuread_application.azureadapp.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

##for enterprise application:

resource "azuread_application" "azureadenterpriseapp" {
  display_name = var.enterprise_service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "spn2" {
  application_id               = azuread_application.azureadenterpriseapp.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]

  feature_tags {
    enterprise = true
    gallery    = true
  }
}