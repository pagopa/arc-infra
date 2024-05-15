locals {
  project    = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product    = "${var.prefix}-${var.env_short}-${var.location_short}"
  ad_product = var.p4pa_owner ? "p4pa-${var.env_short}" : local.product
}
