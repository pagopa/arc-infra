# Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.ad_product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.ad_product}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.ad_product}-adgroup-externals"
}