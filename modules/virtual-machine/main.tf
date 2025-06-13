resource "azurerm_resource_group" "resource_group" {
  name     = "${var.azure_virtual_machine.prefix}-vmresources"
  location = var.azure_virtual_machine.location
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.azure_virtual_machine.prefix}-vm"
  location              = var.azure_virtual_machine.location
  resource_group_name   = azurerm_resource_group.resource_group.name
  network_interface_ids = var.network_interface_ids
  admin_username        = "adminuser"
  size                  = var.azure_virtual_machine.size

  source_image_reference {
    publisher = var.azure_virtual_machine.storage_image_reference_vars.publisher
    offer     = var.azure_virtual_machine.storage_image_reference_vars.offer
    sku       = var.azure_virtual_machine.storage_image_reference_vars.sku
    version   = var.azure_virtual_machine.storage_image_reference_vars.version
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_key_vault_secret" "key_vault_vm_pw" {
  name         = "vmkvpassword"
  value        = random_password.vm_pw.result
  key_vault_id = azurerm_key_vault.password_vault.id
}

resource "random_password" "vm_pw" {
  length = 16
}

# resource "azurerm_security_center_subscription_pricing" "vm_access" {
#   tier          = "Standard"
#   resource_type = "VirtualMachines"
#   subplan       = "P2"
# }



