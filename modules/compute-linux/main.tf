
#Create Public IP Address
resource "azurerm_public_ip" "devops-box-publicip" {
  name                = "devops-box-publicip"
  location            = var.location
  resource_group_name = var.name
  allocation_method   = "Static"
}

# Create network interface
resource "azurerm_network_interface" "devops-box-nic" {
  name                = "devops-box-nic"
  location            = var.location
  resource_group_name = var.name

  ip_configuration {
    name                          = "devops-box-nic-ip"
    subnet_id                     = var.runtime_farm_subnet_id #azurerm_subnet.poc-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.devops-box-publicip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "devops_nic_and_nsg_association" {
  count                     = length(azurerm_network_interface.devops-box-nic.*.id)
  network_interface_id      = element(azurerm_network_interface.devops-box-nic.*.id, count.index)
  network_security_group_id = var.runtime_nsg_id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "devops-box-machine" {
  name                            = var.machinename
  location                        = var.location
  resource_group_name             = var.name
  network_interface_ids           = [azurerm_network_interface.devops-box-nic.id]
  size                            = var.machine_type
  computer_name                   = "devbox"
  admin_username                  = "tfuser"
  disable_password_authentication = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "tfuser"
    public_key = var.ssh_public_key
  }
}

resource "azurerm_virtual_machine_extension" "extension" {
  name                 = "configure-software"
  virtual_machine_id   = azurerm_linux_virtual_machine.devops-box-machine.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${base64encode(templatefile("configure-devopsbox.sh", {
  vmname = "${azurerm_linux_virtual_machine.devops-box-machine.name}"
}))}"
    }
SETTINGS
}



# ## Azure built-in roles
# ## https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
# data "azurerm_role_definition" "storage_role" {
#   name = "Storage File Data SMB Share Contributor"
# }

# resource "azurerm_role_assignment" "storage_fileshare_assignment" {
#   scope              = azurerm_storage_account.storage.id
#   role_definition_id = data.azurerm_role_definition.storage_role.id
#   principal_id       = azurerm_linux_virtual_machine.poc-dev-box.identity[0].principal_id
# }
