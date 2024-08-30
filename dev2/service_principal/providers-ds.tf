module "globals" {
  source = "../globals"
}

provider "azurerm" {
  subscription_id = module.globals.subscription_id
  tenant_id       = module.globals.tenant_id
  features {}
}

provider "azuread" {
  client_id     = module.globals.client_id
  client_secret = module.globals.client_secret
  tenant_id     = module.globals.tenant_id
}