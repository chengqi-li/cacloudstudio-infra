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
        security_rule    = []
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
