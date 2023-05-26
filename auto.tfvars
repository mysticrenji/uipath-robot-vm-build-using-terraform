runtime_rg     = "runtimes-machines-test"
runtime_region = "westeurope"

environment              = "Test Environment"
runtime_vnet_address     = ["10.1.0.0/16"]
runtime_subnet_address   = ["10.1.0.0/24"]
azbastion_subnet_address = ["10.1.1.0/26"]
azb_scl_units            = 2

firewall_allocation_method = "Static" # When the sku is default 'Basic',  allocation method 'Dynamic' works but for 'Standard', it has to be a 'Static'
firewall_sku               = "Standard"

vm_list = {
  "runtimemachine1" = { vm_size = "Standard_D2s_v3", vm_region = "westeurope" }
  # "runtimemachine2" = { vm_size = "Standard_D2s_v3", vm_region = "westeurope" }
}
devops_vm_list = {
  "devops-box" = { vm_size = "Standard_D2s_v3", vm_region = "westeurope" }
}
storage_account_region    = "westeurope"
storage_account_name      = "runtimespocstorage"
storage_account_fileshare = "runtimespocstoragefileshare"
# storage_account_SAS       = ""
storage_account_rg = "renjith-sandbox-storage"

admin_username = "adminuser"
admin_password = "TraingleP@$$word!2023!"
ssh_public_key = ""
orchestratorURL ="https://cloud.uipath.com/mysticrenji/DefaultTenant"
machineKey=""