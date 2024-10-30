resource "azurerm_monitor_action_group" "slackArc" {

  count = var.arc_alert_enabled ? 1 : 0

  name                = "SlackArc"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  short_name          = "Slack-arc"

  email_receiver {
    name                    = "SlackArc"
    email_address           = data.azurerm_key_vault_secret.alert-slack-arc[count.index].value
    use_common_alert_schema = true
  }

}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "Availability" {

  count               = var.arc_alert_enabled ? 1 : 0
  name                = "${local.project}-Availability"
  location            = data.azurerm_resource_group.monitor_rg.location
  resource_group_name = data.azurerm_resource_group.monitor_rg.name

  evaluation_frequency = "P1D"
  window_duration      = "P1D"
  scopes               = [data.azurerm_log_analytics_workspace.log_analytics.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      let interval = totimespan(1m);
      let tot = AzureDiagnostics
          | where requestUri_s has 'cittadini'
          | summarize tot = todouble(count()) by bin(TimeGenerated, interval);
      let errors = AzureDiagnostics
          | where requestUri_s has 'cittadini'
          | where strcmp(httpStatusCode_s,"412") > 0
          | summarize not_ok = count() by bin(TimeGenerated, interval);
      tot
      | join kind=leftouter errors on TimeGenerated
      | project TimeGenerated, availability = (tot - coalesce(not_ok, 0)) / tot, watermark=0.99
      QUERY
    time_aggregation_method = "Average"
    threshold               = 0.99
    operator                = "LessThan"
    metric_measure_column   = "availability"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = false
  workspace_alerts_storage_enabled = false
  description                      = "Trigger alert when Availability is less than 0.99"
  display_name                     = "${var.domain}-${var.env_short}-Availability"
  enabled                          = true
  query_time_range_override        = "P2D"
  skip_query_validation            = false
  action {
    action_groups = [
      azurerm_monitor_action_group.slackArc[0].id
    ]
    custom_properties = {}
  }

  tags = var.tags
}