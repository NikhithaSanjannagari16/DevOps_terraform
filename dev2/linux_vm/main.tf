data "azurerm_key_vault" "keyvault" {
  resource_group_name = module.globals.secretkeyvault_resourcegroup
  name         = module.globals.secretkeyvault
}
data "azurerm_key_vault" "keyvault1" {
  resource_group_name = module.globals.resource_group
  name         = "wu2-${module.globals.environment}-vault01"
}

data "azurerm_key_vault_secret" "kvsecret" {
  name = "sshkey" // Name of secret
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_subnet" "vm_subnet" {
  name                 = "${module.globals.environment}-${module.globals.linuxvm_subnet_name}"
  virtual_network_name = "${module.globals.environment}-vnet"
  resource_group_name  = module.globals.resource_group
}

resource "azurerm_network_interface" "linuxnic" {
  name                = var.linux_vm_nic_name
  location            = module.globals.location
  resource_group_name = module.globals.resource_group
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = var.linux_vm_name
  resource_group_name = module.globals.resource_group
  location            = module.globals.location
  size                = var.linux_vm_size
  admin_username      = "Azadmin"
  network_interface_ids = [
    azurerm_network_interface.linuxnic.id,
  ]

  admin_ssh_key {
    username   = "Azadmin"
    public_key = data.azurerm_key_vault_secret.kvsecret.value
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.linux_vm_sku
    version   = "latest"
  }
  
  # secret {
  #   key_vault_id = data.azurerm_key_vault.keyvault1.id
  # }
}
data "azurerm_backup_policy_vm" "policy" {
  name                = module.globals.recovery_vault_policy_name
  recovery_vault_name = module.globals.recovery_service_vaultname
  resource_group_name =  module.globals.resource_group
}
resource "azurerm_backup_protected_vm" "linuxvm1" {
  resource_group_name = module.globals.resource_group
  recovery_vault_name = module.globals.recovery_service_vaultname
  source_vm_id        = azurerm_linux_virtual_machine.linuxvm.id
  backup_policy_id    = data.azurerm_backup_policy_vm.policy.id
}
resource "azurerm_key_vault_secret" "linux_pwd" {
  key_vault_id = data.azurerm_key_vault.keyvault1.id
  name         = "${module.globals.environment}-linux-vm-sshkey"
  value        = data.azurerm_key_vault_secret.kvsecret.value
  tags = merge(module.globals.default_tags)
}
resource "azurerm_key_vault_secret" "linux_user" {
  key_vault_id = data.azurerm_key_vault.keyvault1.id
  name         = "${module.globals.environment}-linux-vm-username"
  value        = "user:Azadmin"
  tags = merge(module.globals.default_tags)
}