resource "azurerm_resource_group" "infra" {
  name     = module.globals.resource_group
  location = module.globals.location
}

module "storage" {
  source = "./storage"
}

module "network" {
  source = "./network"
}

# module "vault" {
#   source = "./vault"
# }

# module "mssql" {
#   source = "./mssql"
# }

# module "linux_vm" {
#   source = "./linux_vm"
# }

# module "load_balancer" {
#   source = "./load_balancer"
# }

# module "private_dns_zone" {
#   source = "./azure_private_dns_zone"
# }

# module "management_group" {
#   source = "./management_group"
# }

# module "azure_monitor_alertslogging_purpose" {
#   source = "./azure_monitor_alertslogging_purpose"
# }

# module "azure_policies" {
#   source = "./azure_policies"
# }

# module "iam_rle_assignment" {
#   source = "./iam_rle_assignment"
# }

# module "service_principal" {
#   source = "./service_principal"
# }

# module "subscription_level_management" {
#   source = "./subscription_level_management"
# }

# module "tagging" {
#   source = "./tagging"
# }

# module "user_defined_routing_route_table" {
#   source = "./user_defined_routing_route_table"
# }

# module "vm_backup_policy" {
#   source = "./vm_backup_policy"
# }