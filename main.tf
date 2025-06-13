module "key_vault" {
  source          = "./modules/key-vault"
  count           = var.kv_enabled ? 1 : 0
  tenant_id       = var.tenant_id
  azure_key_vault = var.azure_key_vault
  providers = {
    azurerm = azurerm
  }
}
