data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

#
# 🔐 KV
#

data "azurerm_key_vault" "key_vault" {
  name                = local.kv_domain_name
  resource_group_name = local.kv_domain_rg_name
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}