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
    pullpayment-base-url     = var.gpd_payments_pull_base_url
    bizevents-paids-base-url = var.bizevents_paids_base_url
    gpd-service-base-url     = var.gpd_service_base_url
  }
}

resource "kubernetes_config_map" "assistance" {
  metadata {
    name      = "assistance"
    namespace = var.domain
  }

  data = {
    assistance-arc-zendesk-product-id   = "prod-arc"
    assistance-arc-zendesk-organization = "_users_hc_pagopa"
    arc-help-center-url                 = "https://pagamenti.assistenza.pagopa.it/hc/it/requests/new"
    zendesk-action-url                  = "https://pagopa.zendesk.com/access/jwt"
  }
}
