module "virtual-machine" {
  source          = "./virtual-machine"
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  prefix          = var.prefix
}
