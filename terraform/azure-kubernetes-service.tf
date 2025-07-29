module "azure_kubernetes_service" {
  source                   = "./modules/kubernetes-service"
  count                    = var.aks_enabled ? 1 : 0
  azure_kubernetes_service = var.azure_kubernetes_service
  providers = {
    azurerm = azurerm
  }
}
