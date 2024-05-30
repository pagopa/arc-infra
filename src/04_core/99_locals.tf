#
# General
#
locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  vnet_name                = "${local.product}-${var.location_short}-core-vnet"
  vnet_resource_group_name = "${local.product}-${var.location_short}-core-vnet-rg"
}

#
# Api Management
#

locals {
  apim_cert_name_proxy_endpoint   = format("%s-proxy-endpoint-cert", local.project)
  portal_cert_name_proxy_endpoint = format("%s-proxy-endpoint-cert", "portal")

  api_domain        = "api.${var.dns_zone_prefix}.${var.external_domain}"
  portal_domain     = "portal.${var.dns_zone_prefix}.${var.external_domain}"
  management_domain = "management.${var.dns_zone_prefix}.${var.external_domain}"

  # Application Gateway
  apim_api_certificate_name        = replace(local.api_domain, ".", "-")
  apim_portal_certificate_name     = replace(local.portal_domain, ".", "-")
  apim_management_certificate_name = replace(local.management_domain, ".", "-")
}
