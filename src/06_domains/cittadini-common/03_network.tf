# Private Endpoint
module "prv_endpoint_snet" {
  source = "./.terraform/modules/__v3__/subnet"

  name                                      = "${local.project}-private-endpoint-snet"
  resource_group_name                       = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name                      = data.azurerm_virtual_network.vnet.name
  address_prefixes                          = var.cidr_subnet_prv_endpoint
  private_endpoint_network_policies_enabled = true
  service_endpoints                         = []
}

# FE PRIVATE
resource "azurerm_private_endpoint" "fe_private" {
  count = var.private_cdn_enabled ? 1 : 0

  name                = "${local.project}-cdn-fe-private-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.cdn_rg.name
  subnet_id           = module.prv_endpoint_snet.id

  private_dns_zone_group {
    name                 = "${local.project}-cdn-fe-private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.web_core_storage.id]
  }

  private_service_connection {
    name                           = "${local.project}-cdn-fe-private-service-connection"
    private_connection_resource_id = module.cittadini_cdn.storage_id
    is_manual_connection           = false
    subresource_names              = ["web"]
  }

  tags = var.tags
}