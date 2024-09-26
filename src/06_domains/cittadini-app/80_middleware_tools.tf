### Cert Mounter
module "cert_mounter" {
  source = "./.terraform/modules/__v3__/cert_mounter"

  namespace        = var.domain
  certificate_name = replace(local.ingress_hostname, ".", "-")
  kv_name          = data.azurerm_key_vault.key_vault.name
  tenant_id        = data.azurerm_subscription.current.tenant_id

  workload_identity_enabled              = true
  workload_identity_service_account_name = module.workload_identity.workload_identity_service_account_name
  workload_identity_client_id            = module.workload_identity.workload_identity_client_id

  depends_on = [
    module.workload_identity
  ]
}

# TLS Checker
module "tls_checker" {
  source = "./.terraform/modules/__v3__/tls_checker"

  https_endpoint     = local.ingress_hostname
  alert_name         = local.ingress_hostname
  alert_enabled      = true
  helm_chart_present = true
  namespace          = var.domain
  location_string    = var.location_string

  kv_secret_name_for_application_insights_connection_string = data.azurerm_key_vault_secret.appinsights_connection_string.name
  application_insights_resource_group                       = local.monitor_resource_group_name
  application_insights_id                                   = data.azurerm_application_insights.application_insights.id
  application_insights_action_group_ids                     = [data.azurerm_monitor_action_group.slack.id, data.azurerm_monitor_action_group.email.id]

  keyvault_tenant_id = data.azurerm_client_config.current.tenant_id
  keyvault_name      = data.azurerm_key_vault.key_vault.name

  workload_identity_enabled              = true
  workload_identity_service_account_name = module.workload_identity.workload_identity_service_account_name
  workload_identity_client_id            = module.workload_identity.workload_identity_client_id

  depends_on = [
    module.workload_identity
  ]
}

# Reloader
resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v1.0.30"
  namespace  = var.domain

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}