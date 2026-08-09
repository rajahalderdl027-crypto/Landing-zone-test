
variable "kv" {}

resource "azurerm_key_vault" "kv" {
    for_each = var.kv
  name                       =each.value.name
  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  tenant_id                  = each.value.tenant_id
  sku_name                   = "standard"

  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  soft_delete_retention_days  = 90

  public_network_access_enabled = true

  tags = {
    Environment = "Dev"
    Project     = "Terraformtest"
  }
}
resource "azurerm_key_vault_secret" "vm_password" {
  for_each     = var.kv
  name         = "vm-admin-password"
  value        = "Admin@123" 
  key_vault_id = azurerm_key_vault.kv[each.key].id
}