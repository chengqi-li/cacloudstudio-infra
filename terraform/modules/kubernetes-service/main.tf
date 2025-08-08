resource "azurerm_resource_group" "resource_group" {
  for_each = { for k, v in var.azure_kubernetes_service : k => v if v.aks_create || v.acr_create }
  name     = "${each.key}-kubernetes-rg"
  location = each.value.location
}

resource "azurerm_container_registry" "acr" {
  for_each            = { for k, v in var.azure_kubernetes_service : k => v if v.acr_create }
  name                = "${each.key}acr1000"
  resource_group_name = azurerm_resource_group.resource_group[each.key].name
  location            = each.value.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "acr_pull" {
  for_each             = { for k, v in var.azure_kubernetes_service : k => v if v.aks_create && v.acr_create }
  principal_id         = azurerm_kubernetes_cluster.kubernetes_service[each.key].kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr[each.key].id
}

resource "azurerm_kubernetes_cluster" "kubernetes_service" {
  for_each            = { for k, v in var.azure_kubernetes_service : k => v if v.aks_create }
  name                = "${each.key}-aks"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.resource_group[each.key].name
  dns_prefix          = "akssimple"

  default_node_pool {
    name                        = each.value.default_node_pool.name
    node_count                  = each.value.default_node_pool.node_count
    vm_size                     = each.value.default_node_pool.vm_size
    auto_scaling_enabled        = each.value.default_node_pool.auto_scaling_enabled
    temporary_name_for_rotation = each.value.default_node_pool.temporary_name_for_rotation
    max_count                   = each.value.default_node_pool.max_count
    min_count                   = each.value.default_node_pool.min_count
  }

  # linux_profile {
  #   admin_username = each.value.linux_profile.admin_username

  #   ssh_key {
  #     key_data = tls_private_key.ssh[each.key].public_key_openssh
  #   }
  # }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

# resource "tls_private_key" "ssh" {
#   for_each  = var.azure_kubernetes_service
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "azurerm_key_vault_secret" "aks_ssh_private_key" {
#   for_each     = var.azure_kubernetes_service
#   name         = "${each.key}-ssh-private-key"
#   value        = tls_private_key.ssh[each.key].private_key_pem
#   key_vault_id = var.key_vault[each.key].id
# }
