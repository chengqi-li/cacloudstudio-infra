resource "azurerm_resource_group" "resource_group" {
  for_each = { for key, value in var.azure_virtual_network : key => value }
  name     = "${each.key}-network-rg"
  location = each.value.location
}

resource "azurerm_virtual_network" "virtualnetworks" {
  for_each            = { for key, value in var.azure_virtual_network : key => value }
  name                = "${each.key}-virtualnetwork"
  resource_group_name = lookup(azurerm_resource_group.resource_group, each.key).name
  location            = each.value.location
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
}

locals {
  subnets = merge([
    for vnet_key, vnet_value in var.azure_virtual_network : {
      for subnet_key, subnet_value in vnet_value.subnets :
      "${vnet_key}-${subnet_key}" => {
        vnet_key     = vnet_key
        subnet_key   = subnet_key
        vnet_value   = vnet_value
        subnet_value = subnet_value
      }
    }
  ]...)
}

resource "azurerm_subnet" "subnets" {
  for_each             = local.subnets
  name                 = each.key
  resource_group_name  = lookup(azurerm_resource_group.resource_group, each.value.vnet_key).name
  virtual_network_name = lookup(azurerm_virtual_network.virtualnetworks, each.value.vnet_key).name
  address_prefixes     = each.value.subnet_value.address_prefixes
}

resource "azurerm_network_security_group" "nsgs" {
  for_each            = local.subnets
  name                = "${each.key}-network-security-group"
  location            = each.value.vnet_value.location
  resource_group_name = lookup(azurerm_resource_group.resource_group, each.value.vnet_key).name

  security_rule {
    name                       = "DenyAllOutbound"
    priority                   = 4001
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  dynamic "security_rule" {
    for_each = each.value.subnet_value.security_rule
    content {
      name                       = security_rule.value.name
      description                = security_rule.value.description
      priority                   = security_rule.value.priority
      protocol                   = security_rule.value.protocol
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "subnets-nsgs" {
  for_each                  = local.subnets
  subnet_id                 = lookup(azurerm_subnet.subnets, each.key).id
  network_security_group_id = lookup(azurerm_network_security_group.nsgs, each.key).id
}

