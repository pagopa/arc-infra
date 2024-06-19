# general
prefix         = "arc"
env_short      = "d"
env            = "dev"
domain         = "dev"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Subnets
#

aks_cidr_subnet = ["10.1.0.0/17"]

#
# AKS
#

aks_kubernetes_version = "1.29.4"

# https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/482967553/AKS#sku-(dimensionamento)
aks_sku_tier = "Free"

aks_system_node_pool = {
  name                         = "system"
  vm_size                      = "Standard_B2ms"
  os_disk_type                 = "Managed"
  os_disk_size_gb              = "75"
  node_count_min               = "1"
  node_count_max               = "3"
  only_critical_addons_enabled = true
  node_labels                  = { node_name : "aks-system-01", node_type : "system" },
  node_tags                    = { node_tag_1 : "1" },
}

aks_user_node_pool = {
  enabled         = true
  name            = "userdefault"
  vm_size         = "Standard_B8ms"
  os_disk_type    = "Managed"
  os_disk_size_gb = "75"
  node_count_min  = "1"
  node_count_max  = "1"
  node_labels     = { node_name : "aks-userdefault", node_type : "user" },
  node_taints     = [],
  node_tags       = { node_tag_1 : "1" },
}

nginx_ingress_helm_version = "4.10.0"

# chart releases: https://github.com/kedacore/charts/releases
# keda image tags: https://github.com/kedacore/keda/pkgs/container/keda/versions
# keda-metrics-apiserver image tags: https://github.com/kedacore/keda/pkgs/container/keda-metrics-apiserver/versions
keda_helm = {
  chart_version = "2.14.0"
  keda = {
    image_name = "ghcr.io/kedacore/keda"
    image_tag  = "2.8.0@sha256:cce502ff17fd2984af70b4e470b403a82067929f6e4d1888875a52fcb33fa9fd"
  }
  metrics_api_server = {
    image_name = "ghcr.io/kedacore/keda-metrics-apiserver"
    image_tag  = "2.8.0@sha256:4afe231e9ce5ca351fcf10a83479eb0ee2f3e6dc0f386108b89d1b5623d56b14"
  }
}

#
# Dns
#
dns_zone_internal_prefix = "internal.dev"