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
    bizevents-base-url = var.bizevents_base_url
  }
}