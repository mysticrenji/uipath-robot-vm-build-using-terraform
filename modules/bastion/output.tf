output "azb-host-name" {
  value = azurerm_bastion_host.azb-host.name
}

output "azb-host-id" {
  value = azurerm_bastion_host.azb-host.id
}

output "bastionsubnet_name" {
  value = azurerm_subnet.AzureBastionSubnet.name
}

output "bastionsubnet_id" {
  value = azurerm_subnet.AzureBastionSubnet.id
}

output "azb-pubIP-id" {
  value = azurerm_public_ip.azb-publicIP.id
}

output "azb-pubIP-ipadr" {
  value = azurerm_public_ip.azb-publicIP.ip_address
}
