keyvault_enabled = true

azure_key_vault = {
  web = {
    prefix      = "cacloud"
    location    = "westus"
    environment = "web"
  }
}

network_enabled = true

azure_virtual_network = {
  web = {
    address_space = ["10.0.0.0/22"]
    subnets = {
      default = {
        address_prefixes = ["10.0.1.0/24"]
        security_rule = [{
          name                       = "AllowSSHInbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "73.162.251.158/32"
          destination_address_prefix = "*"
          },
          {
            name                       = "AllowHTTPInbound"
            priority                   = 101
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "80"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          },
          {
            name                       = "AllowHTTPSInbound"
            priority                   = 102
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "443"
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
  web = {
    count = 1
  }
}
