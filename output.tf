output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "file_share_name" {
  value = module.storage.file_share_name
}

output "file_share_url" {
  value = module.storage.file_share_url
}

# output "controlserver_public_ip" {
#   value     = module.compute-linux.az_public_ip
# }
