# general
prefix         = "arc"
env_short      = "p"
env            = "prod"
domain         = "prod"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Subnets
#

aks_cidr_system_subnet = ["10.1.0.0/24"]
aks_cidr_user_subnet   = ["10.1.1.0/24"]

#
# AKS
#

aks_kubernetes_version = "1.29.7"

# https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/482967553/AKS#sku-(dimensionamento)
aks_sku_tier       = "Standard"
aks_alerts_enabled = true

aks_system_node_pool = {
  name                         = "arcusys"
  vm_size                      = "Standard_D2ds_v5"
  os_disk_type                 = "Ephemeral"
  os_disk_size_gb              = "75"
  node_count_min               = "1"
  node_count_max               = "3"
  only_critical_addons_enabled = true
  node_labels                  = { node_name : "aks-system-01", node_type : "system" },
  node_tags                    = { node_tag_1 : "1" },
}

aks_user_node_pool = {
  enabled         = true
  name            = "arcuuser"
  vm_size         = "Standard_D8ds_v5"
  os_disk_type    = "Ephemeral"
  os_disk_size_gb = "100"
  node_count_min  = "1"
  node_count_max  = "2"
  node_labels     = { node_name : "aks-userdefault", node_type : "user" },
  node_taints     = [],
  node_tags       = { node_tag_2 : "2" },
}

nginx_ingress_helm_version = "4.11.1"

# chart releases: https://github.com/kedacore/charts/releases
keda_helm_chart_version = "2.14.3"


#
# Dns
#
dns_zone_prefix = "cittadini"
external_domain = "pagopa.it"

### ARGOCD
argocd_helm_release_version = "7.4.5" #2.12.2
