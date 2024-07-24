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