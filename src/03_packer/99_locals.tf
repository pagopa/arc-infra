locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"
  product      = "${var.prefix}-${var.env_short}"
}
