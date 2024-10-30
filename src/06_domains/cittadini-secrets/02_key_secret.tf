#tfsec:ignore:azure-keyvault-ensure-key-expiry
resource "azurerm_key_vault_key" "generated" {
  name         = "${local.project}-sops-key"
  key_vault_id = module.key_vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
  ]
}

data "external" "terrasops_sh" {
  program = [
    "bash", "terrasops.sh"
  ]
  query = {
    env = "${var.location_short}-${var.env}"
  }

}

locals {
  all_enc_secrets_value = flatten([
    for k, v in data.external.terrasops_sh.result : {
      valore = v
      chiave = k
    }
  ])

  config_secret_data = jsondecode(file(var.input_file))
  all_config_secrets_value = flatten([
    for kc, vc in local.config_secret_data : {
      valore = vc
      chiave = kc
    }
  ])

  all_secrets_value = concat(local.all_config_secrets_value, local.all_enc_secrets_value)
}


## Upload all encrypted secrets
#tfsec:ignore:azure-keyvault-ensure-key-expiry
resource "azurerm_key_vault_secret" "secret" {
  for_each = { for i, v in local.all_secrets_value : local.all_secrets_value[i].chiave => i }

  key_vault_id = module.key_vault.id
  name         = local.all_secrets_value[each.value].chiave
  value        = local.all_secrets_value[each.value].valore
  tags = {
    "SOPS" : "True",
    "Domain" : basename(path.cwd)
  }

  depends_on = [
    module.key_vault,
    azurerm_key_vault_key.generated,
    data.external.terrasops_sh
  ]
}
