resource "azurerm_resource_group" "tools_rg" {
  name     = "${local.project}-tools-rg"
  location = var.location

  tags = var.tags
}

resource "azurerm_container_app_environment" "tools_cae" {
  name                = "${local.project}-tools-cae"
  location            = azurerm_resource_group.tools_rg.location
  resource_group_name = azurerm_resource_group.tools_rg.name

  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  infrastructure_subnet_id   = data.azurerm_subnet.cae_tools_snet.id
}
