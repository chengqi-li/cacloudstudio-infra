output "key_vault" {
  value = var.keyvault_enabled ? module.key_vault[0].key_vault : null
}

output "virtualnetworks" {
  value = var.network_enabled ? module.network[0].virtualnetworks : null
}

output "subnets" {
  value = var.network_enabled ? module.network[0].subnets : null
}

output "vm_config" {
  value = var.vm_enabled ? module.virtual_machine[0].vm_config : null
}
