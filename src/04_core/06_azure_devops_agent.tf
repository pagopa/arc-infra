module "azdoa_linux_app" {
  source = "./.terraform/modules/__v3__/azure_devops_agent"
  count  = var.enable_azdoa ? 1 : 0

  name                = "${local.project}-azdoa-vmss-ubuntu-app"
  resource_group_name = data.azurerm_resource_group.azdo_rg.name
  subnet_id           = data.azurerm_subnet.azdoa_snet.id
  subscription_id     = data.azurerm_subscription.current.subscription_id
  location            = var.location
  image_type          = "custom" # enables usage of "source_image_name"
  source_image_name   = "${local.product}-${var.location_short}-packer-azdo-agent-ubuntu2204-image-v1"
  vm_sku              = "Standard_B2ms"

  zones        = var.devops_agent_zones
  zone_balance = var.devops_agent_balance_zones

  tags = var.tags
}

module "azdoa_linux_infra" {
  source = "./.terraform/modules/__v3__/azure_devops_agent"
  count  = var.enable_azdoa ? 1 : 0

  name                = "${local.project}-azdoa-vmss-ubuntu-infra"
  resource_group_name = data.azurerm_resource_group.azdo_rg.name
  subnet_id           = data.azurerm_subnet.azdoa_snet.id
  subscription_id     = data.azurerm_subscription.current.subscription_id
  location            = var.location
  image_type          = "custom" # enables usage of "source_image_name"
  source_image_name   = "${local.product}-${var.location_short}-packer-azdo-agent-ubuntu2204-image-v1"
  vm_sku              = "Standard_B2ms"

  zones        = var.devops_agent_zones
  zone_balance = var.devops_agent_balance_zones

  tags = var.tags
}