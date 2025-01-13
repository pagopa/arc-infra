module "monitoring_function" {
  source     = "./.terraform/modules/__v3__/monitoring_function"
  depends_on = [azurerm_application_insights.application_insights]

  legacy = false

  location            = var.location
  prefix              = "${local.product}-${var.location_short}"
  resource_group_name = azurerm_resource_group.synthetic_rg.name

  application_insight_name              = azurerm_application_insights.application_insights.name
  application_insight_rg_name           = azurerm_application_insights.application_insights.resource_group_name
  application_insights_action_group_ids = [data.azurerm_monitor_action_group.slack.id]

  docker_settings = {
    image_tag = "v1.10.0@sha256:1686c4a719dc1a3c270f98f527ebc34179764ddf53ee3089febcb26df7a2d71d"
  }

  job_settings = {
    cron_scheduling              = "*/5 * * * *"
    container_app_environment_id = data.azurerm_container_app_environment.tools_cae.id
    http_client_timeout          = 30000
  }

  storage_account_settings = {
    private_endpoint_enabled  = var.use_private_endpoint
    table_private_dns_zone_id = var.use_private_endpoint ? data.azurerm_private_dns_zone.storage_account_table.id : null
    replication_type          = var.storage_account_replication_type
  }

  private_endpoint_subnet_id = var.use_private_endpoint ? data.azurerm_subnet.cae_subnet.id : null

  tags = var.tags

  self_alert_configuration = {
    enabled = var.self_alert_enabled
  }

  monitoring_configuration_encoded = templatefile("${path.module}/tpl/monitoring_configuration.json.tpl", {
    env_name         = var.env,
    api_dot_env_name = var.env == "prod" ? "api" : "api.${var.env}"
    alert_enabled    = var.synthetic_alerts_enabled
    appgw_public_ip  = data.azurerm_public_ip.appgateway_public_ip.ip_address
  })
}
