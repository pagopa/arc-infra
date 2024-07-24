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

resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v1.0.30"
  namespace  = kubernetes_namespace.namespace.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}

resource "helm_release" "cert_mounter" {
  name         = "cert-mounter-blueprint"
  repository   = "https://pagopa.github.io/aks-helm-cert-mounter-blueprint"
  chart        = "cert-mounter-blueprint"
  version      = "1.0.4"
  namespace    = var.domain
  timeout      = 120
  force_update = true

  values = [
    templatefile("${path.root}/helm/cert-mounter.yaml.tpl", {
      NAMESPACE        = var.domain,
      KEYVAULT_NAME    = local.kv_domain_name
      CERTIFICATE_NAME = replace(local.kv_ingress_certificate_name, ".", "-"),
    })
  ]
}