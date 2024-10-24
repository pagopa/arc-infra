## Resource group - Redis
resource "azurerm_resource_group" "redis_rg" {
  name     = "${local.project}-redis-rg"
  location = var.location

  tags = var.tags
}

## Redis subnet
module "redis_snet" {
  source = "./.terraform/modules/__v3__/subnet"

  name                                      = "${local.project}-redis-snet"
  resource_group_name                       = local.vnet_resource_group_name
  virtual_network_name                      = local.vnet_name
  address_prefixes                          = var.cidr_subnet_redis
  private_endpoint_network_policies_enabled = true
}

## Redis core
module "redis" {
  source = "./.terraform/modules/__v3__/redis_cache"

  name                          = "${local.project}-redis"
  resource_group_name           = azurerm_resource_group.redis_rg.name
  location                      = azurerm_resource_group.redis_rg.location
  capacity                      = var.redis_params.capacity
  family                        = var.redis_params.family
  sku_name                      = var.redis_params.sku_name
  enable_authentication         = true
  redis_version                 = var.redis_params.version
  public_network_access_enabled = false

  zones = []

  private_endpoint = {
    enabled              = true
    virtual_network_id   = local.vnet_id
    subnet_id            = module.redis_snet.id
    private_dns_zone_ids = [data.azurerm_private_dns_zone.privatelink_redis_azure_com.id]
  }

  // when azure can apply patch?
  patch_schedules = [
    {
      day_of_week    = "Sunday"
      start_hour_utc = 23
    }
  ]

  tags = var.tags
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "redis_url" {
  name         = "cache-standalone-host"
  value        = module.redis.hostname
  content_type = "text/plain"

  key_vault_id = local.kv_domain_id

  tags = var.tags
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "redis_password" {
  name         = "cache-password"
  value        = module.redis.primary_access_key
  content_type = "text/plain"

  key_vault_id = local.kv_domain_id

  tags = var.tags
}
