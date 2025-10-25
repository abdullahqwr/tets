resource "azurerm_key_vault" "this" {
  name                        = "${var.prefix}-kv"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = var.sku_name
  purge_protection_enabled    = var.purge_protection_enabled
  soft_delete_retention_days  = var.soft_delete_retention_days
  enabled_for_disk_encryption = true
  enabled_for_deployment      = true
  enabled_for_template_deployment = true
  public_network_access_enabled   = false
  tags                             = var.tags
}

resource "azurerm_key_vault_access_policy" "aks" {
  key_vault_id = azurerm_key_vault.this.id

  tenant_id = var.tenant_id
  object_id = var.aks_managed_identity_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_access_policy" "github" {
  key_vault_id = azurerm_key_vault.this.id

  tenant_id = var.tenant_id
  object_id = var.github_oidc_object_id

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]
}

resource "azurerm_key_vault_access_policy" "additional" {
  for_each    = toset(var.additional_secret_reader_object_ids)
  key_vault_id = azurerm_key_vault.this.id

  tenant_id = var.tenant_id
  object_id = each.value

  secret_permissions = [
    "Get",
    "List"
  ]
}
