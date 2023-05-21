# Create VNET for Runtime Farm
resource "azurerm_virtual_network" "runtime_farm_vnet" {
  name                = "runtime-vnet"
  address_space       = var.runtime_vnet_address #["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.name
}

# Create Subnet for Runtime Farm
resource "azurerm_subnet" "runtime_farm_subnet" {
  name                                      = "runtime-subnet"
  address_prefixes                          = var.runtime_subnet_address #["10.0.1.0/24"]
  virtual_network_name                      = azurerm_virtual_network.runtime_farm_vnet.name
  resource_group_name                       = var.name
  private_endpoint_network_policies_enabled = true
}

# # Create Private DNS Zone
# resource "azurerm_private_dns_zone" "dns-zone" {
#   name                = var.priv_dns_zone
#   resource_group_name = var.name
# }

# # Create Private DNS Zone Network Link
# resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
#   name                  = "runtime-private-link"
#   resource_group_name   = var.name
#   private_dns_zone_name = azurerm_private_dns_zone.dns-zone.name
#   virtual_network_id    = azurerm_virtual_network.runtime_farm_vnet.id
# }

#}
# # Create Public IP for Runtime Farm
# resource "azurerm_public_ip" "runtime_farm_public_ip" {
#   name                = "runtime-public-ip-${var.machinename}"
#   location            = var.location
#   resource_group_name = var.name
#   allocation_method   = "Static"
# }

# resource "azurerm_network_interface_security_group_association" "runtime_farm_nsg_attach" {
#   network_interface_id      = azurerm_network_interface.runtime_farm_nic.id
#   network_security_group_id = "${var.security_group_id}"
# }
