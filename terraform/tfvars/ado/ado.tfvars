keyvault_enabled = true

azure_key_vault = {
  ado = {
    prefix      = "cacloud"
    location    = "westus"
    environment = "ado"
  }
}

network_enabled = true

azure_virtual_network = {
  ado = {
    address_space = ["10.10.0.0/22"]
    subnets = {
      default = {
        address_prefixes = ["10.10.1.0/24"]
        security_rule = [{
          name                       = "AllowSSHInbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
          }
        ]
      }
    }
  }
}

vm_enabled = true

azure_linux_virtual_machine = {
  ado = {
    count = 1
    size  = "Standard_B2pts_v2"
  }
}
