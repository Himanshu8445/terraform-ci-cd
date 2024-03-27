variable "law_workspace_id" {
  type        = string
  description = <<EOT
  log Analytics workspace Diagnostic Logs will be sent to.
  Example: /subscriptions/<subscription id>/resourceGroups/<resource group>/providers/Microsoft.OperationalInsights/workspaces/<workspace name>
  EOT
}

variable "diagnostic_settings_databricks" {
  type = map(object({
    name      = string
    target_id = string
  }))
}

# Log categories  
variable "databricks_dbfs_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_cluster_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}
variable "databricks_account_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}
variable "databricks_jobs_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_notebook_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_ssh_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_workspace_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_secrets_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}

variable "databricks_sql_permissions_logs" {
  description = <<EOT
  Each log category has a 3 configurable settings:
	  Enabled: should the log source be collected
	  Retention enabled: should the log type have a different retention policy to the Log Analytics workspace retention policy.
	  Retention days: if the retention policy is set for this log type how many days should logs of this type be retained.
    Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
  EOT
  type = object({
    enabled           = bool
    retention_days    = number
    retention_enabled = bool
  })
  default = {
    enabled           = true
    retention_days    = 30
    retention_enabled = false
  }
}