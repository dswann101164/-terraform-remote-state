#########################
# Authentication
#########################

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "client_id" {
  description = "Service Principal App ID"
  type        = string
}

variable "client_secret" {
  description = "Service Principal password"
  type        = string
  sensitive   = true
}

#########################
# Storage Configuration
#########################

variable "resource_group_name" {
  description = "Resource group for Terraform state storage"
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name (must be globally unique, 3-24 chars, lowercase alphanumeric)"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage account name must be 3-24 characters, lowercase letters and numbers only."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "service_principal_object_id" {
  description = "Object ID of the Service Principal (for RBAC)"
  type        = string
}

#########################
# Tags
#########################

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
