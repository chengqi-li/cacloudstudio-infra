data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resource_group" {
  for_each = { for key, value in var.azure_key_vault : key => value }
  name     = "${each.key}-keyvaults-rg"
  location = each.value.location
}

resource "azurerm_key_vault" "key_vault" {
  for_each = { for key, value in var.azure_key_vault : key => value }

  name                = "${each.key}-keyvault"
  location            = each.value.location
  resource_group_name = lookup(azurerm_resource_group.resource_group, each.key).name
  sku_name            = "standard"
  tenant_id           = var.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]
  }
}

