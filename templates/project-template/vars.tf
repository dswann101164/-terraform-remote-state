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
# Infrastructure Config
#########################

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

#########################
# Required Tags
#########################

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  
  # Enforce required tags
  validation {
    condition = (
      contains(keys(var.tags), "Environment") &&
      contains(keys(var.tags), "Application") &&
      contains(keys(var.tags), "Owner") &&
      contains(keys(var.tags), "Cost-Center")
    )
    error_message = "Tags must include: Environment, Application, Owner, and Cost-Center."
  }
}
