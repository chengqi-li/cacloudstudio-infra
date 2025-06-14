resource "azurerm_resource_group" "resource_group" {
  for_each = { for key, value in var.azure_linux_virtual_machine : key => value }
  name     = "${each.key}-vm-resources"
  location = each.value.location
}

locals {
  vm_configs = flatten([
    for key, value in var.azure_linux_virtual_machine : [
      for i in range(value.count) : {
        key   = key
        value = value
        name  = "${key}-${i}"
      }
    ]
  ])
}

resource "azurerm_network_interface" "network_interfaces" {
  for_each            = { for vm in local.vm_configs : vm.name => vm }
  name                = "${each.value.name}-nic"
  location            = each.value.value.location
  resource_group_name = lookup(azurerm_resource_group.resource_group, each.value.key).name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = lookup(var.subnets, "${each.value.key}-default").id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "random_password" "vm_pw" {
  for_each = { for vm in local.vm_configs : vm.name => vm }
  length   = 16
}

resource "azurerm_linux_virtual_machine" "main" {
  for_each = { for vm in local.vm_configs : vm.name => vm }

  name                  = "${each.key}-vm"
  location              = each.value.value.location
  resource_group_name   = lookup(azurerm_resource_group.resource_group, each.value.key).name
  network_interface_ids = [lookup(azurerm_network_interface.network_interfaces, each.value.name).id]
  admin_username        = "adminuser"
  admin_password        = lookup(random_password.vm_pw, each.value.name).result
  size                  = each.value.value.size

  disable_password_authentication = false

  source_image_reference {
    publisher = each.value.value.storage_image_reference_vars.publisher
    offer     = each.value.value.storage_image_reference_vars.offer
    sku       = each.value.value.storage_image_reference_vars.sku
    version   = each.value.value.storage_image_reference_vars.version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_key_vault_secret" "key_vault_vm_pw" {
  for_each     = { for vm in local.vm_configs : vm.name => vm }
  name         = "${each.value.name}-secret"
  value        = lookup(random_password.vm_pw, each.value.name).result
  key_vault_id = lookup(var.key_vault, each.value.key).id
}
