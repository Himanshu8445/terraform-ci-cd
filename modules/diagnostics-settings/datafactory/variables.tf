variable "law_workspace_id" {
  type        = string
  description = <<EOT
  log Analytics workspace Diagnostic Logs will be sent to.
  Example: /subscriptions/<subscription id>/resourceGroups/<resource group>/providers/Microsoft.OperationalInsights/workspaces/<workspace name>
  EOT
}
/*variable "diagnostic_name" {
  type        = string
  description = "Name of the Diagnostic setting. Must be unique to the resource it is set for."
}
variable "target_id" {
  type        = string
  description = <<EOT
    Resource ID for the resource the Diagnostic Setting will monitor.
    Example: /subscriptions/<subscription id>/resourceGroups/<resource group>/providers/Microsoft.EventHub/namespaces/<namespace>
    EOT
}*/

variable "diagnostic_settings_datafactory" {
  type = map(object({
    name      = string
    target_id = string
  }))
}

# Log categories  
variable "activity_run" {
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

variable "pipeline_runs" {
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
variable "trigger_runs" {
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
variable "sandbox_pipeline_runs" {
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
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "sandbox_activity_runs" {
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
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssis_package_event_msgs" {
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
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssis_exe_stats" {
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
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssip_package_event_msg_context" {
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
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssis_package_exe_component_phases" {
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
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssis_package_exe_data_stats" {
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
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "ssis_integration_runtime_logs" {
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
    enabled           = false
    retention_days    = 30
    retention_enabled = false
  }
}

variable "data_factory_metrics" {
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