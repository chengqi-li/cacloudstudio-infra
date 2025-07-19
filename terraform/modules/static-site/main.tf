resource "azurerm_resource_group" "resource_group" {
  for_each = { for key, value in var.azure_static_site : key => value }
  name     = "${each.key}-static-site-rg"
  location = each.value.location
}

resource "azurerm_static_site" "static_site" {
  name                = "cacloudstudio"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

