output "virtualnetworks" {
  value = azurerm_virtual_network.main
}

output "subnets" {
  value = azurerm_subnet.subnets
}
