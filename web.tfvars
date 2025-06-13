kv_enabled = true
azure_virtual_network = {
  web = {
    address_space = ["10.0.0.0/22"]
    subnets = {
      default = {
        address_prefixes = ["10.0.0.0/30"]
      }
    }
  }
}
azure_network_security_group = {
  web = {
    security_rule = [
      {
        name                       = "ssh"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "73.162.251.158/32"
        destination_address_prefix = "*"
      }
    ]
  }
}
azure_key_vault = {
  web = {
    prefix      = "cacloud"
    location    = "westus"
    environment = "web"
  }
}
