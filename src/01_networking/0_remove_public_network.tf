locals {
  dns_zone_prefix_old          = "dev.cittadini-p4pa"
  dns_zone_internal_prefix_old = "internal.dev.cittadini-p4pa"
}

resource "azurerm_dns_zone" "public_old" {
  count = (local.dns_zone_prefix_old == null || var.external_domain == null || var.env_short != "d") ? 0 : 1

  name                = join(".", [local.dns_zone_prefix_old, var.external_domain])
  resource_group_name = azurerm_resource_group.rg_vnet.name
  tags                = var.tags
}

resource "azurerm_dns_caa_record" "cittadini_p4pa_pagopa_it_ns_caa" {
  name                = "@"
  zone_name           = azurerm_dns_zone.public_old[0].name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = var.dns_default_ttl_sec

  record {
    flags = 0
    tag   = "issue"
    value = "letsencrypt.org"
  }

  record {
    flags = 0
    tag   = "issue"
    value = "digicert.com"
  }
  record {
    flags = 0
    tag   = "iodef"
    value = "mailto:security+caa@pagopa.it"
  }

  tags = var.tags
}

resource "azurerm_private_dns_zone" "internal_pagopa_it_old" {
  name                = "${local.dns_zone_internal_prefix_old}.${var.external_domain}"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = merge(
    var.tags,
    local.tags_for_private_dns
  )
}