resource "azurerm_monitor_action_group" "slack_cittadini" {
  count = var.alert_enabled ? 1 : 0

  name                = "slack-${var.domain}"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  short_name          = substr("slack-${var.domain}", 0, 12)

  email_receiver {
    name                    = "slack-${var.domain}"
    email_address           = data.azurerm_key_vault_secret.alert-slack-arc[count.index].value
    use_common_alert_schema = true
  }
  tags = var.tags
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "Availability" {
  count = var.alert_enabled ? 1 : 0

  name                = "${local.project}-Availability"
  location            = data.azurerm_resource_group.monitor_rg.location
  resource_group_name = data.azurerm_resource_group.monitor_rg.name

  evaluation_frequency = "P1D"
  window_duration      = "P1D"
  scopes               = [data.azurerm_application_insights.application_insights.id]
  severity             = 0
  criteria {
    query                   = <<-QUERY
      let interval = totimespan(1m);
      let tot = requests
        | where operation_Name has 'cittadini'
        | summarize tot = todouble(count()) by bin(timestamp, interval);
      let errors = requests
        | where operation_Name has 'cittadini'
        | where strcmp(resultCode,"412") > 0
        | summarize not_ok = count() by bin(timestamp, interval);
      tot
        | join kind=leftouter errors on timestamp
        | project timestamp, availability = (tot - coalesce(not_ok, 0)) / tot, watermark=0.99
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
      azurerm_monitor_action_group.slack_cittadini[0].id
    ]
    custom_properties = {}
  }

  tags = var.tags
}


resource "azurerm_monitor_metric_alert" "CPUClusterUsage" {
  count = var.alert_enabled ? 1 : 0

  name                = "${local.project}-CPU-cluster-usage"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name

  scopes      = [data.azurerm_kubernetes_cluster.aks.id]
  severity    = 0
  frequency   = "PT1H"
  window_size = "PT1H"
  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    threshold        = 80
    operator         = "GreaterThan"
  }

  description = "Trigger alert when CPU cluster usage is greater than 80%"
  enabled     = true
  action {
    action_group_id = azurerm_monitor_action_group.slack_cittadini[0].id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "ram_cluster_usage" {
  count = var.alert_enabled ? 1 : 0

  name                = "${local.project}-RAM-cluster-usage"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name

  scopes      = [data.azurerm_kubernetes_cluster.aks.id]
  severity    = 0
  frequency   = "PT1H"
  window_size = "PT1H"
  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_memory_working_set_percentage"
    aggregation      = "Average"
    threshold        = 80
    operator         = "GreaterThan"
  }

  description = "Trigger alert when RAM cluster usage is greater than 80%"
  enabled     = true
  action {
    action_group_id = azurerm_monitor_action_group.slack_cittadini[0].id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "redis_server_load" {
  count = var.alert_enabled ? 1 : 0

  name                = "${local.project}-redis-server-load"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name

  scopes      = [data.azurerm_redis_cache.redis_common.id]
  severity    = 0
  frequency   = "PT15M"
  window_size = "PT30M"
  criteria {
    metric_namespace = "Microsoft.Cache/redis"
    metric_name      = "allserverLoad"
    aggregation      = "Average"
    threshold        = 80
    operator         = "GreaterThan"
  }

  description = "Trigger alert when Redis serve usage is greater than 80%"
  enabled     = true
  action {
    action_group_id = azurerm_monitor_action_group.slack_cittadini[0].id
  }

  tags = var.tags
}