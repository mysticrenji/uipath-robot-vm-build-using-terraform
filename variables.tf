variable "runtime_region" {}
variable "runtime_rg" {}
variable "vm_list" {}
variable "devops_vm_list" {}

variable "environment" {}
variable "runtime_vnet_address" {}
variable "runtime_subnet_address" {}
variable "azbastion_subnet_address" {}
variable "azb_scl_units" {}

variable "firewall_allocation_method" {}
variable "firewall_sku" {}

variable "admin_password" {
  sensitive = false
}

variable "admin_username" {
  sensitive = false
}

variable "ssh_public_key" {}

# Storage Account Variables
variable "storage_account_rg" {}
variable "storage_account_region" {}
variable "storage_account_name" {}
variable "storage_account_fileshare" {}
# variable "priv_dns_zone" {}
variable "orchestratorURL" {}
variable "machineKey" {}