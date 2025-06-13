module "key_vault" {
  source          = "./modules/key-vault"
  count           = var.kv_enabled ? 1 : 0
  tenant_id       = var.tenant_id
  azure_key_vault = var.azure_key_vault
  providers = {
    azurerm = azurerm
  }
}

module "virtual_network" {
  source                       = "./modules/network"
  count                        = var.network_enabled ? 1 : 0
  azure_virtual_network        = var.azure_virtual_network
  azure_network_security_group = var.azure_network_security_group
  providers = {
    azurerm = azurerm
  }
}
