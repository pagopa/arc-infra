#
# Private DNS Zone
#

# ->> DNS private: internal.ENV.cittadini.pagopa.it
resource "azurerm_private_dns_zone" "internal_pagopa_it" {
  name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

# ->> Storage Account (blob) - private dns zone
resource "azurerm_private_dns_zone" "blob_storage_account" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

# ->> Storage Account (table) - private dns zone
resource "azurerm_private_dns_zone" "table_storage_account" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

# ->> Key Vaults - private dns zone
resource "azurerm_private_dns_zone" "key_vault_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}


# ->> Redis - private dns zone
resource "azurerm_private_dns_zone" "privatelink_redis_cache_windows_net" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}

resource "azurerm_private_dns_zone_virtual_network_link" "all_to_vnet_core" {
  for_each = { for i, v in data.azurerm_resources.sub_resources.resources : data.azurerm_resources.sub_resources.resources[i].name => v }

  name                  = module.vnet_core.name
  resource_group_name   = split("/", each.value["id"])[4]
  private_dns_zone_name = each.value["name"]
  virtual_network_id    = module.vnet_core.id
  registration_enabled  = false

  tags = var.tags
}

moved {
  from = azurerm_private_dns_zone.storage_account
  to   = azurerm_private_dns_zone.blob_storage_account
}
