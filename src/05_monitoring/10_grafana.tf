resource "azurerm_resource_group" "grafana_rg" {
  name     = "${local.product}-${var.location_short_westeurope}-grafana-rg"
  location = var.location

  tags = var.tags
}
#
# 📊 Grafana Managed
#

resource "azurerm_dashboard_grafana" "grafana_dashboard" {
  name                              = "${local.product}-${var.location_short_westeurope}-grafana"
  resource_group_name               = azurerm_resource_group.grafana_rg.name
  location                          = var.location_westeurope
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  zone_redundancy_enabled           = var.grafana_zone_redundancy_enabled
  grafana_major_version             = var.grafana_major_version
  sku                               = "Standard"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "grafana_dashboard_monitoring_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.grafana_dashboard.identity[0].principal_id
}

module "grafana_dashboard" {
  source = "./.terraform/modules/__v3__/grafana_dashboard"

  prefix               = var.prefix
  grafana_api_key      = data.azurerm_key_vault_secret.grafana_token.value
  grafana_url          = azurerm_dashboard_grafana.grafana_dashboard.endpoint
  monitor_workspace_id = local.log_analytics_workspace_id
}

resource "grafana_folder" "sythetic_monitoring" {
  provider = grafana.cloud

  title = "Syntetic Monitoring Dashboard"
}

resource "grafana_dashboard" "sythetic_monitoring" {
  provider = grafana.cloud

  folder = grafana_folder.sythetic_monitoring.uid
  config_json = templatefile("./dashboards/synthetic_monitoring.tpl", {
    subscription_id           = data.azurerm_client_config.current.subscription_id
    resource_group_name       = azurerm_resource_group.monitoring_rg.name
    application_insights_name = azurerm_application_insights.application_insights.name
  })
}
