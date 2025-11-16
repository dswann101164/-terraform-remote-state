######################################################################
# Terraform Remote State Storage Account
# Purpose: Creates Azure Storage Account for storing Terraform state
######################################################################

# Resource Group for state storage
resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Storage Account for Terraform state
resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Security settings
  min_tls_version                 = "TLS1_2"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false

  tags = var.tags
}

# Container for state files
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# RBAC: Grant Service Principal access to storage account
resource "azurerm_role_assignment" "tfstate_sp" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.service_principal_object_id
}
