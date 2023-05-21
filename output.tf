output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "file_share_name" {
  value = module.storage.file_share_name
}

output "file_share_url" {
  value = module.storage.file_share_url
}

# output "storage_account_access_key" {
#   value     = module.storage.storage_account_access_key
#   sensitive = true
# }
