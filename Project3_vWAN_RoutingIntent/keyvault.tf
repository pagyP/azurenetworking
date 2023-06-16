data "azurerm_client_config" "current" {}

resource "random_id" "kvname" {
  byte_length = 5
  prefix = "vault"
}

resource "azurerm_key_vault" "kv" {
  name                            = random_id.kvname.hex
  location                        = azurerm_resource_group.vm.location
  resource_group_name             = azurerm_resource_group.vm.name
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  enable_rbac_authorization       = var.enable_rbac_authorization

  sku_name = "standard"

  tags = local.common_tags

}




resource "azurerm_key_vault_secret" "secret" {
  name         = "vmsecret1"
  value        = random_password.vmsecret.result
  key_vault_id = azurerm_key_vault.kv.id

}

resource "random_password" "vmsecret" {
  length  = 32
  special = true
}