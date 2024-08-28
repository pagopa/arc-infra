# SECRETS

#tfsec:ignore:azure-keyvault-ensure-secret-expiry tfsec:ignore:azure-keyvault-content-type-for-secret
resource "azurerm_key_vault_secret" "application_insights_connection_string" {
  name         = "appinsights-connection-string"
  key_vault_id = local.kv_domain_id
  value        = data.azurerm_application_insights.application_insights.connection_string
}


# JWT
module "jwt" {
  source = "./.terraform/modules/__v3__/jwt_keys"

  jwt_name            = "jwt"
  key_vault_id        = local.kv_domain_id
  cert_common_name    = "apim"
  cert_password       = ""
  tags                = var.tags
  early_renewal_hours = 0

}