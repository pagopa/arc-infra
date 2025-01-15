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
