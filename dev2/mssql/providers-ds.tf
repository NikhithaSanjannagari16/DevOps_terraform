module "globals" {
  source = "../globals"
}

provider "azurerm" {
  subscription_id = module.globals.subscription_id
  tenant_id       = module.globals.tenant_id
  features {}
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config  = {
    subscription_id      = module.globals.subscription_id
    storage_account_name = module.globals.state_storage_account
    resource_group_name  = module.globals.resource_group
    container_name       = module.globals.state_container_name
    key                  = "terraform/${module.globals.environment}/network"
  }
}

data "terraform_remote_state" "vault" {
  backend = "azurerm"
  config  = {
    subscription_id      = module.globals.subscription_id
    storage_account_name = module.globals.state_storage_account
    resource_group_name  = module.globals.resource_group
    container_name       = module.globals.state_container_name
    key                  = "terraform/${module.globals.environment}/vault"
  }
}
