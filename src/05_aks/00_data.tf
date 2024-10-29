data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

#
# 🌐 Networking
#
data "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_private_dns_zone" "internal" {
  name                = local.internal_dns_zone_name
  resource_group_name = local.internal_dns_zone_resource_group_name
}

#
# AKS & Docker
#

data "azurerm_container_registry" "acr" {
  name                = local.docker_registry_name
  resource_group_name = local.docker_rg_name
}

#
# Key Vault
#
data "azurerm_key_vault" "kv_core_ita" {
  name                = local.kv_core_name
  resource_group_name = local.kv_core_rg_name
}
