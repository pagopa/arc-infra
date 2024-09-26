resource "kubernetes_namespace" "namespace_system" {
  metadata {
    name = "${var.domain}-system"
  }
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.domain
  }
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "aks_apiserver_url" {
  name         = "${local.aks_name}-apiserver-url"
  value        = "https://${local.aks_api_url}:443"
  content_type = "text/plain"

  key_vault_id = local.kv_domain_id
}

module "domain_pod_identity" {
  source = "./.terraform/modules/__v3__/kubernetes_pod_identity"
  count  = var.env_short == "u" ? 1 : 0 # Awaiting merge https://github.com/pagopa/arc-be/pull/106

  resource_group_name = local.aks_resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_subscription.current.tenant_id
  cluster_name        = local.aks_name

  identity_name = "${var.domain}-pod-identity"
  namespace     = kubernetes_namespace.namespace.metadata[0].name
  key_vault_id  = local.kv_domain_id

  key_permissions    = ["Get", "Decrypt", "Encrypt"]
  secret_permissions = ["Get"]
}