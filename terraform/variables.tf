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

#############################
# Virtual Machine variables #
#############################
variable "vm_enabled" {
  type        = bool
  description = "virtual machine module enabled or not"
  default     = false
}

variable "azure_linux_virtual_machine" {
  description = "map of variables for azure virtual machine"
  type = map(
    object({
      location = optional(string, "westus")
      size     = optional(string, "Standard_B2s")
      count    = optional(number, 0)

      storage_image_reference_vars = optional(object({
        publisher = optional(string, "Canonical")
        offer     = optional(string, "0001-com-ubuntu-server-jammy")
        sku       = optional(string, "22_04-lts")
        version   = optional(string, "latest")
        }), {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      })
    })
  )
}

#########################
# Static Site variables #
#########################
variable "static_site_enabled" {
  type        = bool
  description = "static site module enabled or not"
  default     = false
}

variable "azurerm_static_site" {
  description = "map of variables for azure static site"
  type = map(
    object({
      location = optional(string, "westus")
    })
  )
}

################################
# Kubernetes Service variables #
################################
variable "aks_enabled" {
  type        = bool
  description = "aks module enabled or not"
  default     = false
}

variable "azure_kubernetes_service" {
  type = map(object({
    location   = optional(string, "westus")
    aks_create = optional(bool, true)
    acr_create = optional(bool, true)
    default_node_pool = object({
      name                        = string
      node_count                  = optional(number, 1)
      vm_size                     = string
      auto_scaling_enabled        = optional(bool, false)
      temporary_name_for_rotation = optional(string, "temp_node")
      max_count                   = optional(number)
      min_count                   = optional(number)
    })
    linux_profile = object({
      admin_username = string
    })
  }))
}

