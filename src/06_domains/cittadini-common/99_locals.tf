locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  # AKS
  aks_name                = "${local.product}-${var.location_short}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.location_short}-${var.env}-aks-rg"
  aks_api_url             = data.azurerm_kubernetes_cluster.aks.private_fqdn

  #
  # 🌐 Networking
  #

  vnet_name                = "${local.project_core}-vnet"
  vnet_resource_group_name = "${local.project_core}-vnet-rg"
  vnet_id                  = data.azurerm_virtual_network.vnet.id

  #
  # 🖥️ Monitor
  #
  monitor_resource_group_name  = "${local.project_core}-monitor-rg"
  log_analytics_workspace_name = "${local.project_core}-law"
  log_analytics_workspace_id   = data.azurerm_log_analytics_workspace.log_analytics.id

  #
  # 🔐 KV
  #
  key_vault_name         = "${local.project}-kv"
  key_vault_rg_name      = "${local.project}-sec-rg"
  key_vault_id           = data.azurerm_key_vault.key_vault.id
  key_vault_core_name    = "${local.project_core}-kv"
  key_vault_core_rg_name = "${local.project_core}-sec-rg"
  key_vault_core_id      = data.azurerm_key_vault.key_vault_core.id

  #
  # 💙 Azure
  #

  tenant_id       = data.azurerm_subscription.current.tenant_id
  subscription_id = data.azurerm_subscription.current.subscription_id
}