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



