resource "azurerm_resource_group" "aks_rg" {
  name     = "${local.project}-aks-rg"
  location = var.location

  tags = var.tags
}

module "aks" {
  source = "./.terraform/modules/__v3__/kubernetes_cluster"

  name                       = local.aks_name
  location                   = var.location
  dns_prefix                 = local.project
  resource_group_name        = azurerm_resource_group.aks_rg.name
  kubernetes_version         = var.aks_kubernetes_version
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics.id
  sku_tier                   = var.aks_sku_tier

  #
  # 🤖 System node pool
  #
  system_node_pool_name = var.aks_system_node_pool.name

  ### vm configuration
  system_node_pool_vm_size         = var.aks_system_node_pool.vm_size
  system_node_pool_os_disk_type    = var.aks_system_node_pool.os_disk_type
  system_node_pool_os_disk_size_gb = var.aks_system_node_pool.os_disk_size_gb
  system_node_pool_node_count_min  = var.aks_system_node_pool.node_count_min
  system_node_pool_node_count_max  = var.aks_system_node_pool.node_count_max

  ### K8s node configuration
  system_node_pool_only_critical_addons_enabled = var.aks_system_node_pool.only_critical_addons_enabled
  system_node_pool_node_labels                  = var.aks_system_node_pool.node_labels
  system_node_pool_tags                         = var.aks_system_node_pool.node_tags

  #
  # 👤 User node pool
  #
  user_node_pool_enabled = var.aks_user_node_pool.enabled
  user_node_pool_name    = var.aks_user_node_pool.name
  ### vm configuration
  user_node_pool_vm_size         = var.aks_user_node_pool.vm_size
  user_node_pool_os_disk_type    = var.aks_user_node_pool.os_disk_type
  user_node_pool_os_disk_size_gb = var.aks_user_node_pool.os_disk_size_gb
  user_node_pool_node_count_min  = var.aks_user_node_pool.node_count_min
  user_node_pool_node_count_max  = var.aks_user_node_pool.node_count_max
  ### K8s node configuration
  user_node_pool_node_labels = var.aks_user_node_pool.node_labels
  user_node_pool_node_taints = var.aks_user_node_pool.node_taints
  user_node_pool_tags        = var.aks_user_node_pool.node_tags

  #
  # ☁️ Network
  #
  vnet_id             = data.azurerm_virtual_network.vnet.id
  vnet_subnet_id      = module.aks_snet_system.id
  vnet_user_subnet_id = module.aks_snet_user.id

  outbound_ip_address_ids = azurerm_public_ip.aks_outbound.*.id
  private_cluster_enabled = var.aks_private_cluster_is_enabled

  network_profile = {
    docker_bridge_cidr  = "172.17.0.1/16"
    dns_service_ip      = "10.0.0.10"
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
    network_policy      = "cilium"
    outbound_type       = "loadBalancer"
    service_cidr        = "10.0.0.0/16"
  }

  # Iam
  aad_admin_group_ids = var.env_short == "p" ? [data.azuread_group.adgroup_admin.object_id] : [
    data.azuread_group.adgroup_admin.object_id,
    data.azuread_group.adgroup_developers.object_id,
    data.azuread_group.adgroup_externals.object_id
  ]

  addon_azure_policy_enabled                     = true
  addon_azure_key_vault_secrets_provider_enabled = true
  addon_azure_pod_identity_enabled               = true

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  microsoft_defender_log_analytics_workspace_id = var.env_short == "p" ? data.azurerm_log_analytics_workspace.log_analytics.id : null

  custom_metric_alerts = null
  alerts_enabled       = var.aks_alerts_enabled
  action = [
    {
      action_group_id    = data.azurerm_monitor_action_group.slack.id
      webhook_properties = null
    },
    {
      action_group_id    = data.azurerm_monitor_action_group.email.id
      webhook_properties = null
    }
  ]

  tags = merge(
    var.tags,
    {
      "grafana" = "yes"
    }
  )
}

#
# Pod identity permissions
#
resource "azurerm_role_assignment" "managed_identity_operator_vs_aks_managed_identity" {
  scope                = azurerm_resource_group.aks_rg.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = module.aks.identity_principal_id
}

#
# ACR connection
#
# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "aks_to_acr" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_id
}
