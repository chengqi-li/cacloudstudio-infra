module "virtual-machine" {
  source = "./virtual-machine"
  ten_id = var.tenant_id
  sub_id = var.subscription_id
  prefix = var.prefix
}
