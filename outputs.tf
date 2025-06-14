output "key-vault" {
  value = var.keyvault_enabled ? module.key_vault[0].key-vault : null
}

output "virtualnetworks" {
  value = var.network_enabled ? module.network[0].virtualnetworks : null
}

output "subnets" {
  value = var.network_enabled ? module.network[0].subnets : null
}
