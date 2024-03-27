####################################################################################################
# Azure Diagnostic Setting for Data Factory                                                        #
# This module should be used to create a diagnostic setting for a Data Factory resource in Azure. #                                                                                 #
#################################################################################################### 
#########################
# Provider Requirements #
#########################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.91.0"
    }
  }
}

#############
# resources #
#############

resource "azurerm_monitor_diagnostic_setting" "data_factory" {
  for_each                       = var.diagnostic_settings_datafactory
  name                           = each.value["name"]
  target_resource_id             = each.value["target_id"]
  log_analytics_workspace_id     = var.law_workspace_id
  log_analytics_destination_type = "Dedicated"
  log {
    category = "ActivityRuns"
    enabled  = var.activity_run.enabled
    retention_policy {
      enabled = var.activity_run.retention_enabled
      days    = var.activity_run.retention_days
    }
  }
  log {
    category = "PipelineRuns"
    enabled  = var.pipeline_runs.enabled
    retention_policy {
      enabled = var.pipeline_runs.retention_enabled
      days    = var.pipeline_runs.retention_days
    }
  }
  log {
    category = "TriggerRuns"
    enabled  = var.trigger_runs.enabled
    retention_policy {
      enabled = var.trigger_runs.retention_enabled
      days    = var.trigger_runs.retention_days
    }
  }
  log {
    category = "SandboxPipelineRuns"
    enabled  = var.sandbox_pipeline_runs.enabled
    retention_policy {
      enabled = var.sandbox_pipeline_runs.retention_enabled
      days    = var.sandbox_pipeline_runs.retention_days
    }
  }
  log {
    category = "SandboxActivityRuns"
    enabled  = var.sandbox_activity_runs.enabled
    retention_policy {
      enabled = var.sandbox_activity_runs.retention_enabled
      days    = var.sandbox_activity_runs.retention_days
    }
  }
  log {
    category = "SSISPackageEventMessages"
    enabled  = var.ssis_package_event_msgs.enabled
    retention_policy {
      enabled = var.ssis_package_event_msgs.retention_enabled
      days    = var.ssis_package_event_msgs.retention_days
    }
  }
  log {
    category = "SSISPackageExecutableStatistics"
    enabled  = var.ssis_exe_stats.enabled
    retention_policy {
      enabled = var.ssis_exe_stats.retention_enabled
      days    = var.ssis_exe_stats.retention_days
    }
  }
  log {
    category = "SSISPackageEventMessageContext"
    enabled  = var.ssip_package_event_msg_context.enabled
    retention_policy {
      enabled = var.ssip_package_event_msg_context.retention_enabled
      days    = var.ssip_package_event_msg_context.retention_days
    }
  }
  log {
    category = "SSISPackageExecutionComponentPhases"
    enabled  = var.ssis_package_exe_component_phases.enabled
    retention_policy {
      enabled = var.ssis_package_exe_component_phases.retention_enabled
      days    = var.ssis_package_exe_component_phases.retention_days
    }
  }
  log {
    category = "SSISPackageExecutionDataStatistics"
    enabled  = var.ssis_package_exe_data_stats.enabled
    retention_policy {
      enabled = var.ssis_package_exe_data_stats.retention_enabled
      days    = var.ssis_package_exe_data_stats.retention_days
    }
  }
  log {
    category = "SSISIntegrationRuntimeLogs"
    enabled  = var.ssis_integration_runtime_logs.enabled
    retention_policy {
      enabled = var.ssis_integration_runtime_logs.retention_enabled
      days    = var.ssis_integration_runtime_logs.retention_days
    }
  }
  metric {
    category = "AllMetrics"
    enabled  = var.data_factory_metrics.enabled
    retention_policy {
      enabled = var.data_factory_metrics.retention_enabled
      days    = var.data_factory_metrics.retention_days
    }
  }
}