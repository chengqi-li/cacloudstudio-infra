module "key_vault" {
  source          = "./modules/key-vault"
  count           = var.keyvault_enabled ? 1 : 0
  azure_key_vault = var.azure_key_vault
  providers = {
    azurerm = azurerm
  }
}
