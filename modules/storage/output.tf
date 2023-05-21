output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "file_share_name" {
  value = azurerm_storage_share.fileshare.name
}

output "file_share_url" {
  value = "${azurerm_storage_account.storage_account.primary_file_host}/${azurerm_storage_share.fileshare.name}"
}

output "storage_account_access_key" {
  value     = azurerm_storage_account.storage_account.primary_access_key
  sensitive = true
}
