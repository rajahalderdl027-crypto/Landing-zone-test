

resource "azurerm_key_vault_secret" "vm_password" {
  name         = "adminuser"
  value        = "Admin@123"
  key_vault_id = azurerm_key_vault.kv.id
}