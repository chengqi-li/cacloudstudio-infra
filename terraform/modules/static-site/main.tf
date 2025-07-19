resource "azurerm_resource_group" "resource_group" {
  for_each = { for key, value in var.azure_static_site : key => value }
  name     = "${each.key}-static-site-rg"
  location = each.value.location
}

resource "azurerm_static_site" "static_site" {
  for_each            = { for key, value in var.azure_static_site : key => value }
  name                = "cacloudstudio"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.resource_group[each.key].name
}

