module "virtual_machine" {
  source                      = "./modules/virtual-machine"
  count                       = var.vm_enabled ? 1 : 0
  azure_linux_virtual_machine = var.azure_linux_virtual_machine
  key_vault                   = var.keyvault_enabled ? module.key_vault[0].key_vault : null
  virtualnetworks             = var.network_enabled ? module.network[0].virtualnetworks : null
  subnets                     = var.network_enabled ? module.network[0].subnets : null
  providers = {
    azurerm = azurerm
  }
}
