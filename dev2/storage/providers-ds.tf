module "globals" {
  source = "../globals"
}

provider "azurerm" {
  subscription_id = module.globals.subscription_id
  tenant_id       = module.globals.tenant_id
  features {}
}
