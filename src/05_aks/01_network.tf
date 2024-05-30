module "aks_snet" {
  source                                        = "./.terraform/modules/__v3__/subnet"
  name                                          = "${local.project}-aks-snet"
  address_prefixes                              = var.aks_cidr_subnet
  resource_group_name                           = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name                          = data.azurerm_virtual_network.vnet.name
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
  service_endpoints                             = ["Microsoft.Storage"]
}

resource "azurerm_public_ip" "aks_outbound" {
  count = var.aks_num_outbound_ips

  name                = "${local.project}-aks-outbound-pip-${count.index + 1}"
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = var.aks_ip_availability_zones

  tags = var.tags
}

#
# DNS private - Records
#

resource "azurerm_private_dns_a_record" "ingress" {
  name                = local.ingress_hostname_prefix
  zone_name           = data.azurerm_private_dns_zone.internal.name
  resource_group_name = local.internal_dns_zone_resource_group_name
  ttl                 = 3600
  records             = [local.ingress_load_balancer_ip]
}