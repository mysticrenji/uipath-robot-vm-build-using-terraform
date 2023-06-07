#Create Public IP Address
resource "azurerm_public_ip" "runtime_farm_publicip" {
  name                = "runtime-farm-publicip-${var.machinename}"
  location            = var.location
  resource_group_name = var.name
  allocation_method   = "Static"
}

# Create NIC for Runtime Farm - Network Interface Card
resource "azurerm_network_interface" "runtime_farm_nic" {
  name                = "runtime-nic-${var.machinename}"
  location            = var.location
  resource_group_name = var.name

  ip_configuration {
    name                          = "runtime-ipconfig-${var.machinename}"
    subnet_id                     = var.runtime_farm_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.runtime_farm_publicip.id
  }
}

# Associate the NSG to the Runtimes's NIC
resource "azurerm_network_interface_security_group_association" "runtime_nic_and_nsg_association" {
  count                     = length(azurerm_network_interface.runtime_farm_nic.*.id)
  network_interface_id      = element(azurerm_network_interface.runtime_farm_nic.*.id, count.index)
  network_security_group_id = var.runtime_nsg_id
}

resource "azurerm_windows_virtual_machine" "runtime_machine" {
  name                = var.machinename
  resource_group_name = var.name
  location            = var.location
  size                = var.machine_type
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.runtime_farm_nic.id,
  ]
  identity {
    type = "SystemAssigned"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

}

# https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows#property-values
resource "azurerm_virtual_machine_extension" "software" {
  name                 = "configure-softwares"
  virtual_machine_id   = azurerm_windows_virtual_machine.runtime_machine.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = <<SETTINGS
  {
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.playbook.rendered)}')) | Out-File -filepath configurewinrm.ps1\" && powershell -ExecutionPolicy Unrestricted -File configurewinrm.ps1 -AdmincredsUserName ${data.template_file.playbook.vars.AdmincredsUserName} -AdmincredsPassword ${data.template_file.playbook.vars.AdmincredsPassword} -StorageAccountName ${data.template_file.playbook.vars.StorageAccountName} -FileShareName ${data.template_file.playbook.vars.FileShareName} -StorageAccountKeys ${data.template_file.playbook.vars.StorageAccountKeys}"
  }

  SETTINGS
}

data "template_file" "playbook" {
  template = file("configurewinrm.ps1")
  vars = {
    AdmincredsUserName = "${azurerm_windows_virtual_machine.runtime_machine.admin_username}"
    AdmincredsPassword = "${azurerm_windows_virtual_machine.runtime_machine.admin_password}"
    StorageAccountName = "${var.storage_account_name}"
    FileShareName      = "${var.storage_account_fileshare}"
    StorageAccountKeys = "${var.storage_account_SAS}"
  }
}

resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  name                       = "az_monitor_agent"
  virtual_machine_id         = azurerm_windows_virtual_machine.runtime_machine.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = "true"
  depends_on                 = [azurerm_virtual_machine_extension.software]

}

# data collection rule association
resource "azurerm_monitor_data_collection_rule_association" "data_collection_association" {
  name                    = "data-collection-link-${var.machinename}"
  target_resource_id      = azurerm_windows_virtual_machine.runtime_machine.id
  data_collection_rule_id = var.data_collection_rule_id
}

# Join the virtual machine to the Azure Active Directory domain
# resource "azurerm_virtual_machine_domain_join_extension" "join-ad" {
#   virtual_machine_id         = azurerm_virtual_machine.example.id
#   name                       = "vm-domainjoin"
#   type                       = "Microsoft.Compute/virtualMachines/extensions"
#   publisher                  = "Microsoft.Compute"
#   type_version               = "1.1"
#   auto_upgrade_minor_version = true

#   settings = <<SETTINGS
#     {
#       "name": "${var.domain_name}",
#       "ouPath": "${var.ou_path}",
#       "user": "${var.domain_user}",
#       "restart": "true",
#       "options": "3"
#     }
#   SETTINGS
# }
resource "null_resource" "ansible_connection" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    environment = {
      username           = "${var.admin_username}"
      password           = "${var.admin_password}"
      storageaccountname = "${var.storage_account_name}"
      filesharename      = "${var.storage_account_fileshare}"
      storageaccountkeys = nonsensitive("${var.storage_account_SAS}")
      orchestratorurl    = "${var.orchestratorURL}"
      machinekey         = "${var.machineKey}"
      host               = "${azurerm_windows_virtual_machine.runtime_machine.private_ip_address}"
      playbook           = "playbook.yml "
    }
    command = "$(pwd)/execute-playbook.sh"
    # interpreter = ["/bin/sh", "-c"]
  }
  depends_on = [azurerm_virtual_machine_extension.software]
}
