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

aks_kubernetes_version = "1.27.7"

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

nginx_ingress_helm_version = "4.7.2"

#
# Dns
#
dns_zone_internal_prefix = "internal.dev"