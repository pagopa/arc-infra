locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"

  azdo_managed_identity_rg_name = "${local.project}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-arc-iac-deploy", "azdo-${var.env}-arc-iac-plan"])
}
