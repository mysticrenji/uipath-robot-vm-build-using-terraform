# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#   NSG / Security rules for Azure Bastion Host to Inbound & Outbound traffic
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# * * * * * * *  NSG / Security rule for Runtimes to allow only SSH/RDP traffic from the Azure Bastion * * * * * * *
resource "azurerm_network_security_group" "runtime_nsg" {
  name                = "runtime-nsg"
  location            = var.location
  resource_group_name = var.name

  security_rule {
    name                       = "AllowIB_SSHRDP_fromBastion"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "445", "22", "3389", "5985", "5986"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

# # * * * * * * *  NSG / Security rule for Azure Bastion * * * * * * *
# resource "azurerm_network_security_group" "azb_nsg" {
#   name                = "azb-nsg"
#   location            = var.location
#   resource_group_name = var.name

#   # * * * * * * IN-BOUND Traffic * * * * * * #

#   security_rule {
#     # Ingress traffic from Internet on 443 is enabled
#     name                       = "AllowIB_HTTPS443_Internet"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "Internet"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     # Ingress traffic from Internet on 443 is enabled
#     name                       = "AllowIB_SSH22_Internet"
#     priority                   = 101
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "Internet"
#     destination_address_prefix = "*"
#   }

#   # Allowing WINRM to go through Bastion -> Private IP Runtimes. Disable this block if not required
#   security_rule {
#     # Ingress traffic from Internet on 443 is enabled
#     name                       = "AllowIB_WINRM_Internet"
#     priority                   = 105
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "5986"
#     source_address_prefix      = "Internet"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     # Ingress traffic for control plane activity that is GatewayManger to be able to talk to Azure Bastion
#     name                       = "AllowIB_TCP443_GatewayManager"
#     priority                   = 110
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "GatewayManager"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     # Ingress traffic for health probes, enabled AzureLB to detect connectivity
#     name                       = "AllowIB_TCP443_AzureLoadBalancer"
#     priority                   = 120
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "AzureLoadBalancer"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     # Ingress traffic for data plane activity that is VirtualNetwork service tag
#     name                       = "AllowIB_BastionHost_Commn8080"
#     priority                   = 130
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_ranges    = ["8080", "5701"]
#     source_address_prefix      = "VirtualNetwork"
#     destination_address_prefix = "VirtualNetwork"
#   }

#   security_rule {
#     # Deny all other Ingress traffic
#     name                       = "DenyIB_any_other_traffic"
#     priority                   = 900
#     direction                  = "Inbound"
#     access                     = "Deny"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   # * * * * * * OUT-BOUND Traffic * * * * * * #

#   # Egress traffic to the target VM subnets over ports 3389 and 22
#   security_rule {
#     name                       = "AllowOB_SSHRDP_VirtualNetwork"
#     priority                   = 100
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_ranges    = ["3389", "22"]
#     source_address_prefix      = "*"
#     destination_address_prefix = "VirtualNetwork"
#   }
#   # Egress traffic to AzureCloud over 443
#   security_rule {
#     name                       = "AllowOB_AzureCloud"
#     priority                   = 105
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "AzureCloud"
#   }
#   # Egress traffic for data plane communication between the Bastion and VNets service tags
#   security_rule {
#     name                       = "AllowOB_BastionHost_Comn"
#     priority                   = 110
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_ranges    = ["8080", "5701"]
#     source_address_prefix      = "VirtualNetwork"
#     destination_address_prefix = "VirtualNetwork"
#   }

#   # Egress traffic for SessionInformation
#   security_rule {
#     name                       = "AllowOB_GetSessionInformation"
#     priority                   = 120
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "Internet"
#   }
# }

# # Associate the NSG to the AZBastionHost Subnet
# resource "azurerm_subnet_network_security_group_association" "azbsubnet-and-nsg-association" {
#   network_security_group_id = azurerm_network_security_group.azb_nsg.id
#   subnet_id                 = var.azb_subnet_id
# }
