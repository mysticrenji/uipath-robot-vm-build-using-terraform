variable "location" {}
variable "name" {}
variable "machinename" {}
variable "machine_type" {}
variable "runtime_vnet_name" {}
variable "runtime_subnet_address" {}
variable "runtime_nsg_id" {}
variable "runtime_farm_subnet_id" {}
variable "storage_account_name" {}
variable "storage_account_fileshare" {}
variable "storage_account_SAS" {}
variable "admin_username" {}
variable "admin_password" {}
variable "orchestratorURL" {}
variable "machineKey" {}
variable "data_collection_rule_id" {}
variable "tags" {
  type = map(any)

  default = {
    terraform = "true"
  }
}