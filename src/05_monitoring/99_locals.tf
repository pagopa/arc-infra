locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  #
  # 🖥️ Monitor
  #

  monitor_resource_group_name  = "${local.project_core}-monitor-rg"
  log_analytics_workspace_name = "${local.project_core}-law"
  log_analytics_workspace_id   = data.azurerm_log_analytics_workspace.log_analytics.id

}
