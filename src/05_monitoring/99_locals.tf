locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  #
  # Network
  #
  vnet_core_resource_group_name = "${local.project_core}-vnet-rg"
  vnet_core_name                = "${local.project_core}-vnet"

  #
  # 🖥️ Monitor
  #

  monitor_resource_group_name     = "${local.project_core}-monitor-rg"
  log_analytics_workspace_name    = "${local.project_core}-law"
  log_analytics_workspace_id      = data.azurerm_log_analytics_workspace.log_analytics.id
  monitor_action_group_slack_name = "SlackPagoPA"

  api_domain             = "api.${var.dns_zone_prefix}.${var.external_domain}"
  internal_suffix_domain = "internal.${var.dns_zone_prefix}.${var.external_domain}"
}
