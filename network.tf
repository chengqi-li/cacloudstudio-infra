module "network" {
  source                       = "./modules/network"
  count                        = var.network_enabled ? 1 : 0
  azure_virtual_network        = var.azure_virtual_network
  providers = {
    azurerm = azurerm
  }
}
