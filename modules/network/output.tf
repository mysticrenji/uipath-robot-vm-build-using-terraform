# output "public_ip" {
#   value = azurerm_public_ip.runtime_farm_public_ip.fqdn
# }

output "runtime_farm_subnet" {
  value = azurerm_subnet.runtime_farm_subnet.id
}

output "runtime_vnet_name" {
  value = azurerm_virtual_network.runtime_farm_vnet.name
}
