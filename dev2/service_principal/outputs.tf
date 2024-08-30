output "enterprise_service_principal_name" {
  value =  azuread_application.azureadenterpriseapp.display_name
}

output "service_principal_name" {
  value = azuread_application.azureadapp.display_name
}