### Resource group - CDN
resource "azurerm_resource_group" "cdn_rg" {
  name     = "${local.project}-cdn-rg"
  location = var.location

  tags = var.tags
}

# CDN
module "cittadini_cdn" {
  source = "./.terraform/modules/__v3__/cdn/"

  name                = "cittadini"
  prefix              = local.product
  resource_group_name = azurerm_resource_group.cdn_rg.name
  location            = var.location
  cdn_location        = var.cdn_location

  hostname                     = "${var.dns_zone_prefix}.${var.external_domain}"
  dns_zone_name                = "${var.dns_zone_prefix}.${var.external_domain}"
  dns_zone_resource_group_name = local.vnet_resource_group_name

  storage_account_replication_type = "ZRS"

  https_rewrite_enabled      = true
  index_document             = "index.html"
  error_404_document         = "error_404.html"
  log_analytics_workspace_id = local.log_analytics_workspace_id

  keyvault_id                                      = local.key_vault_core_id
  tenant_id                                        = local.tenant_id
  azuread_service_principal_azure_cdn_frontdoor_id = var.azuread_service_principal_azure_cdn_frontdoor_id
  keyvault_resource_group_name                     = local.key_vault_core_rg_name
  keyvault_subscription_id                         = local.subscription_id
  keyvault_vault_name                              = local.key_vault_core_name
  custom_hostname_kv_enabled                       = true

  delivery_rule_rewrite = concat(
    [{
      name  = "defaultApplication"
      order = 2
      conditions = [
        {
          condition_type   = "url_path_condition"
          operator         = "Equal"
          match_values     = ["/"]
          negate_condition = false
          transforms       = null
        },
        {
          condition_type   = "url_file_extension_condition"
          operator         = "LessThanOrEqual"
          match_values     = ["0"]
          negate_condition = false
          transforms       = null
        }
      ]
      url_rewrite_action = {
        source_pattern          = "/"
        destination             = "/index.html"
        preserve_unmatched_path = false
      }
    }]
  )

  global_delivery_rule = {
    cache_expiration_action       = []
    cache_key_query_string_action = []
    modify_request_header_action  = []

    # HSTS
    modify_response_header_action = [{
      action = "Overwrite"
      name   = "Strict-Transport-Security"
      value  = "max-age=31536000"
      },
      {
        action = "Append"
        name   = "X-Content-Type-Options"
        value  = "nosniff"
      },
      {
        action = "Overwrite"
        name   = "X-Frame-Options"
        value  = "SAMEORIGIN"
      },
      {
        action = "Append"
        name   = "Content-Security-Policy-Report-Only"
        value  = "script-src 'self'; style-src 'self' 'unsafe-inline'; "
      }
    ]
  }

  tags = var.tags
}