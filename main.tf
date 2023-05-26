# Create Resource Group for Runtime Farm
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}
resource "azurerm_resource_group" "runtime_farm" {
  name     = var.runtime_rg
  location = var.runtime_region
}

module "virtual_networks" {
  source                 = "./modules/network"
  location               = var.runtime_region
  name                   = var.runtime_rg
  runtime_vnet_address   = var.runtime_vnet_address
  runtime_subnet_address = var.runtime_subnet_address
  depends_on             = [azurerm_resource_group.runtime_farm, time_sleep.wait_30_seconds]
}

module "storage" {
  source                    = "./modules/storage"
  storage_account_rg        = var.storage_account_rg
  storage_account_region    = var.storage_account_region
  storage_account_name      = var.storage_account_name
  storage_account_fileshare = var.storage_account_fileshare
  depends_on                = [module.virtual_networks, time_sleep.wait_30_seconds]
}

# module "bastionhost" {
#   source                     = "./modules/bastion"
#   location                   = var.runtime_region
#   environment                = var.environment
#   rg_name                    = var.runtime_rg
#   firewall_allocation_method = var.firewall_allocation_method
#   firewall_sku               = var.firewall_sku
#   runtime_vnet_name          = module.virtual_networks.runtime_vnet_name
#   azbastion_subnet_address   = var.azbastion_subnet_address
#   azb_scl_units              = var.azb_scl_units
#   depends_on                 = [module.virtual_networks, time_sleep.wait_30_seconds]
# }


module "networksecuritygroup" {
  source   = "./modules/security"
  location = var.runtime_region
  name     = var.runtime_rg
  #azb_subnet_id = module.bastionhost.bastionsubnet_id
  environment = var.environment
  depends_on  = [module.virtual_networks, time_sleep.wait_30_seconds]
}


module "compute-windows" {
  source                    = "./modules/compute-win"
  for_each                  = var.vm_list
  machinename               = each.key
  machine_type              = each.value.vm_size
  location                  = each.value.vm_region
  name                      = var.runtime_rg
  runtime_subnet_address    = var.runtime_subnet_address
  runtime_vnet_name         = module.virtual_networks.runtime_vnet_name
  runtime_nsg_id            = module.networksecuritygroup.runtime_nsg_id
  runtime_farm_subnet_id    = module.virtual_networks.runtime_farm_subnet
  depends_on                = [module.networksecuritygroup, time_sleep.wait_30_seconds]
  storage_account_name      = var.storage_account_name
  storage_account_fileshare = var.storage_account_fileshare
  storage_account_SAS       = module.storage.storage_account_access_key
  admin_password            = var.admin_password
  admin_username            = var.admin_username
  orchestratorURL           = var.orchestratorURL
  machineKey                = var.machineKey
}

module "compute-linux" {
  source                 = "./modules/compute-linux"
  for_each               = var.devops_vm_list
  machinename            = each.key
  machine_type           = each.value.vm_size
  location               = each.value.vm_region
  name                   = var.runtime_rg
  runtime_nsg_id         = module.networksecuritygroup.runtime_nsg_id
  runtime_farm_subnet_id = module.virtual_networks.runtime_farm_subnet
  ssh_public_key         = var.ssh_public_key
  depends_on             = [module.networksecuritygroup, module.virtual_networks, time_sleep.wait_30_seconds]
}
