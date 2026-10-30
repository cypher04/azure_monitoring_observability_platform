output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log-workspace.id
}

output "monitoring_workspace_id" {
  value = azurerm_monitor_workspace.mon-workspace.id
}

output "log_analytics_workspace_guid" {
  value = azurerm_log_analytics_workspace.log-workspace.workspace_id
}