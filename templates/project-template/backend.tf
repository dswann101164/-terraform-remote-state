terraform {
  # Configure remote state backend
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-dev"           # Match your storacct deployment
    storage_account_name = "sttfstatedev001"          # Match your storacct deployment
    container_name       = "tfstate"
    key                  = "my-project/terraform.tfstate"  # Change per project
  }
}
