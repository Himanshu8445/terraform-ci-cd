variable "data_factory" {
  type = map(object({
    name                            = string
    location                        = string
    resource_group_name             = string
    assign_identity                 = bool
    public_network_enabled          = bool
    managed_virtual_network_enabled = bool
    github_configuration = list(object({
      account_name    = string
      branch_name     = string
      git_url         = string
      repository_name = string
      root_folder     = string
    }))
  }))
}

variable "adf_additional_tags" {
  type        = map(string)
  description = "Additional tags for data factory"
  default     = {}
}

variable "data_factory_integration_runtime_azure" {
  type = map(object({
    name              = string
    data_factory_name = string
    location          = string
    compute_type      = string
    core_count        = number
    ttl               = number
  }))
}