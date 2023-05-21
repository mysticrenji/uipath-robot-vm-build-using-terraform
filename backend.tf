terraform {
  backend "azurerm" {
    resource_group_name  = "renjith-sandbox-terraform"
    storage_account_name = "renjithsandboxstorage"
    container_name       = "terraformstate"
    key                  = "terraform.tfstate"

  }
}
