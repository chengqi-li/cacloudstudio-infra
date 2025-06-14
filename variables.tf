#######################
# Key vault variables #
#######################
variable "keyvault_enabled" {
  type        = bool
  description = "enable keyvault module or not"
  default     = false
}

variable "azure_key_vault" {
  description = "map of variables for azure key vault"
  type = map(
    object({
      location = optional(string, "westus")
    })
  )
}

#####################
# Network variables #
#####################
variable "network_enabled" {
  type        = bool
  description = "enable network module or not"
  default     = false
}

variable "azure_virtual_network" {
  description = "map of variables for azure virtual network"
  type = map(
    object({
      location      = optional(string, "westus")
      address_space = optional(list(string), [])
      dns_servers   = optional(list(string), [])
      subnets = map(
        object({
          address_prefixes = optional(list(string), [])
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
        })
      )
  }))
}
