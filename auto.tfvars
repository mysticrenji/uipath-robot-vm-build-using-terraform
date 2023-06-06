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

admin_username  = "adminuser"
admin_password  = "TraingleP@$$word!2023!"
ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQDMj0ZvY9WukWdu5/II0tW687Ll+mkxhSlw9mwc5L7PrAEicaCyTck+q9upMIYaBzLIHXsn2QWNCUs3HPJgV6zId7TTf8uJFfxn/EJZ9hSO08sk0DjJAE6jdKOeF+2uPyWM5SOAyrI43dvTKLwRWw/nAc0JbDmibrKPH5RED+aVSd/oAUEetQfwLVxKdPfmmWmfdjKEEaImi9U0ZiG4RL9bkv5OXbSpzJI56PCfUnoAA3EInzX52duDDa39aILlVdpDUvh7GcIPa6cpJDfUSSdlXt/4zacGAzT1heHcmEZidx2bjkIE5q8E2cBQ3QyuhDABUJb1L5r629QT6CfZPtmqpWvx+dCbDa7z/pCvhSnsqKPtHhY/BJeF4Gv61EjVroszxW01EUAeIMcnNt968CIBpUSwntXFoTrrr6K7yo68yxBwzYKfbCjGDiDT1dVMAREdmPc6L4+05LiVbxXL8wUiHYhN2RifkUP48nka1/7VlQ+9bfGR9RvxTjXu+VNes= codespace@codespaces-2d497d"
orchestratorURL = "https://cloud.uipath.com/mysticrenji/DefaultTenant"
machineKey      = ""