variable "tenant_id" {}

variable "subscription_id" {}

variable "kv_enabled" {
  type = bool
}

variable "azure_key_vault" {
  description = "map of variables for azure key vault"
  type = map(
    object({
      prefix      = optional(string, "cacloud")
      location    = optional(string, "westus")
      environment = optional(string, "web")
    })
  )
}

variable "azure_virtual_network" {
  description = "map of variables for azure virtual network"
  type = map(
    object({
      prefix        = optional(string, "cacloud")
      location      = optional(string, "westus")
      environment   = optional(string, "web")
      address_space = optional(list(string), [])
      dns_servers   = optional(list(string), [])
      subnets = map(
        object({
          address_prefixes = optional(list(string), [])
        })
      )
  }))
}

variable "azure_network_security_group" {
  description = "map of variables for network security group"
  type = map(object({
    location = optional(string, "westus")
    security_rule = optional(list(object({
      name                       = string
      description                = optional(string)
      priority                   = string
      protocol                   = string
      direction                  = string
      access                     = string
      source_port_range          = optional(string)
      destination_port_range     = optional(string)
      source_address_prefix      = optional(string)
      destination_address_prefix = optional(string)
    })))
  }))
}


