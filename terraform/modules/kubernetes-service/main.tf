resource "azurerm_resource_group" "resource_group" {
  for_each = { for key, value in var.azure_kubernetes_service : key => value }
  name     = "${each.key}-kubernetes-rg"
  location = each.value.location
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "kubernetes_service" {
  for_each            = { for key, value in var.azure_kubernetes_service : key => value }
  name                = "${each.key}-aks"
  location            = each.value.location
  resource_group_name = lookup(azurerm_resource_group.resource_group, each.key).name
  dns_prefix          = "aks_simple"

  default_node_pool {
    name                        = each.value.default_node_pool.name
    node_count                  = each.value.default_node_pool.node_count
    vm_size                     = each.value.default_node_pool.vm_size
    auto_scaling_enabled        = each.value.default_node_pool.auto_scaling_enabled
    temporary_name_for_rotation = each.value.default_node_pool.temporary_name_for_rotation
  }

  linux_profile {
    admin_username = each.value.linux_profile.admin_username

    ssh_key {
      key_data = tls_private_key.ssh.public_key_openssh
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}
