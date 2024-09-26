locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}-${var.location_short}"

  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  #
  # AKS
  #

  aks_name                = "${local.product}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.env}-aks-rg"

  #
  # 💙 Azure
  #

  tenant_id       = data.azurerm_subscription.current.tenant_id
  subscription_id = data.azurerm_subscription.current.subscription_id

  #
  # 🔐 KV
  #

  kv_domain_id      = data.azurerm_key_vault.key_vault.id
  kv_domain_name    = "${local.project}-kv"
  kv_domain_rg_name = "${local.project}-sec-rg"

  #
  # DNS
  #

  internal_dns_zone_name = "internal.${var.dns_zone_prefix}.${var.external_domain}"
  ingress_hostname       = "citizen.${local.internal_dns_zone_name}"

  #
  # 🖥️ Monitor
  #

  application_insights_name       = "${local.project_core}-appinsights"
  monitor_resource_group_name     = "${local.project_core}-monitor-rg"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"
}