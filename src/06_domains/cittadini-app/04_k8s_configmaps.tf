resource "kubernetes_config_map" "appinsights_config" {
  metadata {
    name      = "appinsights-config"
    namespace = var.domain
  }

  data = {
    "applicationinsights.json" = file("./k8s-file/appinsights-config/applicationinsights.json")
  }
}

resource "kubernetes_config_map" "rest_client" {
  metadata {
    name      = "rest-client"
    namespace = var.domain
  }

  data = {
    bizevents-base-url   = var.bizevents_base_url
    pullpayment-base-url = var.gpd_payments_pull_base_url
  }
}

resource "kubernetes_config_map" "assistance" {
  metadata {
    name      = "assistance"
    namespace = var.domain
  }

  data = {
    assistance-arc-zendesk-product-id   = "prod-arc"
    assistance-arc-zendesk-organization = "_users_hc_arc"
    arc-help-center-url                 = " https://portalearc.zendesk.com/hc/it/requests/new"
  }
}
