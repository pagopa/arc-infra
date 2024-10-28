locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  vnet_name                = "${local.project_core}-vnet"
  vnet_resource_group_name = "${local.project_core}-vnet-rg"

  # AKS
  aks_name                 = "${local.project}-aks"
  ingress_load_balancer_ip = cidrhost(var.aks_cidr_user_subnet[0], -6)

  # Monitor
  monitor_resource_group_name     = "${local.project_core}-monitor-rg"
  log_analytics_workspace_name    = "${local.project_core}-law"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  # ACR DOCKER
  docker_rg_name       = "${local.project_core}-container-registry-rg"
  docker_registry_name = replace("${local.project_core}-common-acr", "-", "")

  # DNS
  internal_dns_zone_name                = "internal.${var.dns_zone_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.project_core}-vnet-rg"
  ingress_hostname_prefix               = "citizen"

  ### KV
  kv_core_name    = "arc-${var.env_short}-itn-core-kv"
  kv_core_rg_name = "arc-${var.env_short}-itn-core-sec-rg"

  ### ARGOCD
  argocd_internal_url = "argocd.internal.${var.dns_zone_prefix}.${var.external_domain}"
}
