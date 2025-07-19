module "staticsite" {
  source            = "./modules/static-site"
  count             = var.static_site_enabled ? 1 : 0
  azure_static_site = var.azurerm_static_site
  providers = {
    azurerm = azurerm
  }
}
