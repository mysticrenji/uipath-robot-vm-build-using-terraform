resource "azurerm_resource_group" "rg_storage" {
  location = var.storage_account_region
  name     = var.storage_account_rg
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg_storage.name
  location                 = azurerm_resource_group.rg_storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.rg_storage]
}

resource "azurerm_storage_share" "fileshare" {
  name                 = var.storage_account_fileshare
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = 20
  depends_on           = [azurerm_storage_account.storage_account]
}

# Create Private Endpoint
# resource "azurerm_private_endpoint" "endpoint" {
#   name                = "priv-endpoint-storage"
#   resource_group_name = azurerm_resource_group.rg_storage.name
#   location            = azurerm_resource_group.rg_storage.location
#   subnet_id           = var.runtime_farm_subnet
#   private_service_connection {
#     name                           = "priv-endpoint-storage-connection"
#     private_connection_resource_id = azurerm_storage_account.storage_account.id
#     is_manual_connection           = false
#     subresource_names              = ["file"] #https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
#   }
# }

# Create DNS A Record
# resource "azurerm_private_dns_a_record" "dns_a" {
#   name                = "priv-dns-a-record"
#   zone_name           = var.priv_dns_zone
#   resource_group_name = var.runtime_rg
#   ttl                 = 300
#   records             = [azurerm_private_endpoint.endpoint.private_service_connection.0.private_ip_address]
# }
# data "azurerm_storage_account_sas" "sas_string" {
#   connection_string = azurerm_storage_account.storage_account.primary_connection_string
#   https_only        = true
#   signed_version    = "2017-07-29"

#   resource_types {
#     service   = true
#     container = false
#     object    = false
#   }

#   services {
#     blob  = true
#     queue = false
#     table = false
#     file  = true
#   }

#   start  = "2023-05-17T00:00:00Z"
#   expiry = "2024-05-16T00:00:00Z"

#   permissions {
#     read    = true
#     write   = true
#     delete  = true
#     list    = true
#     add     = true
#     create  = true
#     update  = true
#     process = true
#     tag     = true
#     filter  = true
#   }
# }
