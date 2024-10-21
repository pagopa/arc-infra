resource "azurerm_resource_group" "sec_rg" {
  name     = local.key_vault_rg_name
  location = var.location

  tags = var.tags
}

#
# Kv + Policy
#

module "key_vault" {
  source = "./.terraform/modules/__v3__/key_vault/"

  name                          = local.key_vault_name
  location                      = var.location
  resource_group_name           = azurerm_resource_group.sec_rg.name
  tenant_id                     = local.tenant_id
  soft_delete_retention_days    = 90
  public_network_access_enabled = true

  tags = var.tags
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_group_policy" {
  key_vault_id = module.key_vault.id

  tenant_id = local.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "GetRotationPolicy", "Encrypt", "Decrypt"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Restore"]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover"]
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_developers_policy" {
  count = contains(["d", "u"], var.env_short) ? 1 : 0

  key_vault_id = module.key_vault.id

  tenant_id = local.tenant_id
  object_id = data.azuread_group.adgroup_developers.object_id

  key_permissions     = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt"]
  secret_permissions  = ["Get", "List", "Set", "Delete", ]
  storage_permissions = []
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import",
    "Delete", "Restore", "Purge", "Recover"
  ]
}

resource "azurerm_key_vault_access_policy" "adgroup_externals_policy" {
  count = contains(["d", "u"], var.env_short) ? 1 : 0

  key_vault_id = module.key_vault.id

  tenant_id = local.tenant_id
  object_id = data.azuread_group.adgroup_externals.object_id

  key_permissions         = ["Get", "List", "Encrypt", "Decrypt", "GetRotationPolicy"]
  secret_permissions      = ["Get", "List", "Set", "Delete", ]
  storage_permissions     = []
  certificate_permissions = ["Get", "List"]
}


data "azurerm_user_assigned_identity" "iac_federated_azdo" {
  for_each            = local.azdo_iac_managed_identities
  name                = each.key
  resource_group_name = local.azdo_managed_identity_rg_name
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_managed_identities" {
  for_each = local.azdo_iac_managed_identities

  key_vault_id = module.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_user_assigned_identity.iac_federated_azdo[each.key].principal_id

  key_permissions    = ["Get", "List", "Decrypt", "Verify", "GetRotationPolicy"]
  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]

  storage_permissions = []
}
