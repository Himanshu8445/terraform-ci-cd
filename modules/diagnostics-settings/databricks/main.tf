##################################################################################################
# Azure Diagnostic Setting for Databricks                                                        #
# This module should be used to create a diagnostic setting for a Databricks resource in Azure. #                                                                               #
################################################################################################## 
#########################
# Provider Requirements #
#########################
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #  version = ">=2.59.0"
    }
  }
}

#############
# resources #
#############

resource "azurerm_monitor_diagnostic_setting" "databricks" {
  for_each                   = var.diagnostic_settings_databricks
  name                       = each.value["name"]
  target_resource_id         = each.value["target_id"]
  log_analytics_workspace_id = var.law_workspace_id
  log {
    category = "dbfs"
    enabled  = var.databricks_dbfs_logs.enabled
    retention_policy {
      enabled = var.databricks_dbfs_logs.retention_enabled
      days    = var.databricks_dbfs_logs.retention_days
    }
  }
  log {
    category = "clusters"
    enabled  = var.databricks_cluster_logs.enabled
    retention_policy {
      enabled = var.databricks_cluster_logs.retention_enabled
      days    = var.databricks_cluster_logs.retention_days
    }
  }
  log {
    category = "accounts"
    enabled  = var.databricks_account_logs.enabled
    retention_policy {
      enabled = var.databricks_account_logs.retention_enabled
      days    = var.databricks_account_logs.retention_days
    }
  }
  log {
    category = "jobs"
    enabled  = var.databricks_jobs_logs.enabled
    retention_policy {
      enabled = var.databricks_jobs_logs.retention_enabled
      days    = var.databricks_jobs_logs.retention_days
    }
  }
  log {
    category = "notebook"
    enabled  = var.databricks_notebook_logs.enabled
    retention_policy {
      enabled = var.databricks_notebook_logs.retention_enabled
      days    = var.databricks_notebook_logs.retention_days
    }
  }
  log {
    category = "ssh"
    enabled  = var.databricks_ssh_logs.enabled
    retention_policy {
      enabled = var.databricks_ssh_logs.retention_enabled
      days    = var.databricks_ssh_logs.retention_days
    }
  }
  log {
    category = "workspace"
    enabled  = var.databricks_workspace_logs.enabled
    retention_policy {
      enabled = var.databricks_workspace_logs.retention_enabled
      days    = var.databricks_workspace_logs.retention_days
    }
  }
  log {
    category = "secrets"
    enabled  = var.databricks_secrets_logs.enabled
    retention_policy {
      enabled = var.databricks_secrets_logs.retention_enabled
      days    = var.databricks_secrets_logs.retention_days
    }
  }
  log {
    category = "sqlPermissions"
    enabled  = var.databricks_sql_permissions_logs.enabled
    retention_policy {
      enabled = var.databricks_sql_permissions_logs.retention_enabled
      days    = var.databricks_sql_permissions_logs.retention_days
    }
  }
}