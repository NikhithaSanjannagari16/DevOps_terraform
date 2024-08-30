output "mysql_name" {
  value = azurerm_mssql_server.mysql.name
}

output "mysql_admin_user" {
  value = azurerm_mssql_server.mysql.administrator_login
}
