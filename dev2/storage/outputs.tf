output "default_storage_url" {
  value = "https://${azurerm_storage_account.devinfra.name}.blob.core.windows.net/"
}