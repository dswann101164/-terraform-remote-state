######################################################################
# Example: Simple Resource Group Deployment
# Replace this with your actual infrastructure code
######################################################################

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Add your infrastructure resources here
# Examples:
# - Virtual networks
# - Virtual machines
# - Storage accounts
# - etc.
