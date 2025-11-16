# Enterprise Terraform Remote State Setup - Complete Checklist

## 🎯 Goal
Set up production-ready Terraform remote state storage in Azure with proper security, following enterprise patterns.

---

## Phase 1: Azure Foundation (One-Time Setup)

### ☐ 1.1 Create Service Principal for Terraform
```bash
az ad sp create-for-rbac \
  --name "terraform-[environment]-[project]" \
  --role Contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID
```

**Save these values securely:**
- `appId` → `client_id`
- `password` → `client_secret`
- `tenant` → `tenant_id`
- Subscription ID from Azure Portal

### ☐ 1.2 Verify Service Principal
```bash
# Login as SP to test
az login --service-principal \
  -u YOUR_APP_ID \
  -p YOUR_PASSWORD \
  --tenant YOUR_TENANT_ID

# List subscriptions to confirm access
az account list --output table
```

---

## Phase 2: Deploy Remote State Storage

### ☐ 2.1 Create `storacct` Project Structure
```
storacct/
├── main.tf              # Storage account definition
├── providers.tf         # Azure provider config
├── vars.tf              # Variable declarations
├── terraform.tfvars     # Non-secret values
├── secrets.auto.tfvars  # Secret values (git-ignored)
└── .gitignore           # Exclude secrets & state
```

### ☐ 2.2 Create .gitignore
```gitignore
# Terraform state files
*.tfstate
*.tfstate.*

# Secrets
secrets.auto.tfvars
*.secrets.tfvars

# Terraform directories
.terraform/
.terraform.lock.hcl

# Crash logs
crash.log
```

### ☐ 2.3 Deploy Storage Account
```bash
cd storacct/
terraform init
terraform plan
terraform apply
```

**Verify in Azure Portal:**
- ☐ Resource group created: `rg-tfstate-[env]`
- ☐ Storage account created: `sttfstate[env][unique]`
- ☐ Container exists: `tfstate`
- ☐ RBAC: Service Principal has "Storage Blob Data Contributor"

---

## Phase 3: Configure First Project with Remote State

### ☐ 3.1 Create Project Structure
```
1-windows/  (or your project name)
├── backend.tf           # Remote state config
├── providers.tf         # Provider with SP auth
├── vars.tf              # Variable declarations
├── terraform.tfvars     # Non-secret config
├── secrets.auto.tfvars  # Secrets (git-ignored)
├── main.tf              # Root module
├── .gitignore           # Same as storacct
└── modules/
    ├── resource-group/
    ├── network/
    └── compute/
```

### ☐ 3.2 Create backend.tf
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-[env]"
    storage_account_name = "sttfstate[env][unique]"
    container_name       = "tfstate"
    key                  = "project-name/terraform.tfstate"
  }
}
```

### ☐ 3.3 Configure Provider with SP Auth
```hcl
provider "azurerm" {
  features {}
  
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}
```

### ☐ 3.4 Initialize with Remote Backend
```bash
terraform init -reconfigure
terraform validate
terraform plan
terraform apply
```

---

## Phase 4: Verification & Testing

### ☐ 4.1 Verify Remote State is Working
**Check Azure Storage:**
- ☐ Navigate to storage account in Azure Portal
- ☐ Open "Containers" → "tfstate"
- ☐ Verify blob exists: `project-name/terraform.tfstate`
- ☐ Download and inspect (should be JSON)

### ☐ 4.2 Test State Locking
```bash
# Terminal 1: Start a long-running plan
terraform plan

# Terminal 2: Try to run another command (should fail with lock error)
terraform plan
```

### ☐ 4.3 Verify No Local State
- ☐ Confirm no `terraform.tfstate` file in project directory
- ☐ Only `.terraform/` directory exists locally

---

## Phase 5: Security Best Practices

### ☐ 5.1 Secrets Management
- ☐ Never commit `secrets.auto.tfvars` to Git
- ☐ Store SP credentials in password manager/vault
- ☐ Rotate SP secrets quarterly (minimum)
- ☐ Use least-privilege RBAC roles

### ☐ 5.2 Storage Account Security
- ☐ Enable "Secure transfer required" (HTTPS only)
- ☐ Configure storage account firewall rules
- ☐ Enable soft delete on containers
- ☐ Enable versioning for state files
- ☐ Consider Private Endpoints for production

### ☐ 5.3 Access Control
- ☐ Limit who has access to storage account
- ☐ Use separate SPs for different environments
- ☐ Implement break-glass procedures
- ☐ Audit access logs regularly

---

## Phase 6: Team Enablement

### ☐ 6.1 Document for Team
- ☐ How to get SP credentials
- ☐ How to set up `secrets.auto.tfvars`
- ☐ Standard tagging requirements
- ☐ Backend configuration patterns

### ☐ 6.2 Template Repository
- ☐ Create project template with backend pre-configured
- ☐ Include standard modules
- ☐ Document naming conventions
- ☐ Provide example `.tfvars` files

### ☐ 6.3 CI/CD Integration (Optional)
- ☐ Store SP credentials in pipeline secrets
- ☐ Configure backend authentication
- ☐ Implement state file validation
- ☐ Set up automated testing

---

## 📋 Quick Reference: File Templates

### Template: secrets.auto.tfvars
```hcl
# Service Principal credentials
subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_secret   = "your-client-secret-here"

# VM/resource passwords
admin_password = "Strong-Password-Here!123"
```

### Template: terraform.tfvars
```hcl
# Infrastructure configuration
resource_group_name = "rg-myproject-dev"
location           = "eastus"

# Network settings
vnet_name          = "vnet-myproject-dev"
address_space      = ["10.0.0.0/16"]

# Required tags
tags = {
  Environment   = "Dev"
  Application   = "MyProject"
  Owner         = "Your Name"
  "Cost-Center" = "IT-Shared"
  Type          = "Server"
}
```

---

## 🚨 Common Gotchas

### Issue: "Failed to get existing workspaces"
**Solution:** SP needs "Storage Blob Data Contributor" role, not just "Contributor"

### Issue: "Error locking state"
**Solution:** Check firewall rules on storage account, ensure SP can access

### Issue: "Backend initialization required"
**Solution:** Run `terraform init -reconfigure` after backend changes

### Issue: Version conflicts
**Solution:** Use `terraform init -upgrade` to update provider versions

---

## 🎓 Next Steps

After completing this checklist:
1. ✅ Set up additional environments (dev, staging, prod)
2. ✅ Create project templates
3. ✅ Implement pipeline automation
4. ✅ Document disaster recovery procedures
5. ✅ Train team on remote state workflows

---

## 📚 Additional Resources

- [Terraform Azure Backend Docs](https://www.terraform.io/docs/language/settings/backends/azurerm.html)
- [Azure Storage Security](https://docs.microsoft.com/en-us/azure/storage/common/storage-security-guide)
- [Service Principal Best Practices](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal)

---

**Last Updated:** 2025-11-16  
**Tested With:** Terraform v1.x, AzureRM Provider v3.117+
