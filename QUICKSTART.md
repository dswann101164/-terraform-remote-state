# 🚀 Quick Start - Terraform Remote State in Azure

> **Time:** 15 minutes | **Skill Level:** Beginner

## Copy-Paste Commands (Customize Where Needed)

### 1️⃣ Create Service Principal
```bash
# Replace YOUR_SUBSCRIPTION_ID
az ad sp create-for-rbac \
  --name "terraform-dev" \
  --role Contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID

# Get Object ID (save this output)
az ad sp show --id YOUR_APP_ID --query id -o tsv
```

**Save these values:**
- appId → `client_id`
- password → `client_secret`
- tenant → `tenant_id`
- Object ID from second command

---

### 2️⃣ Deploy Storage Account

```bash
# Copy template
cp -r templates/storacct ./storacct
cd storacct

# Create secrets file
cp secrets.auto.tfvars.example secrets.auto.tfvars

# Edit secrets.auto.tfvars (add your SP credentials)
# Edit terraform.tfvars (make storage_account_name unique)

# Deploy
terraform init
terraform plan
terraform apply
```

---

### 3️⃣ Create Your First Project

```bash
# Copy template
cp -r templates/project-template ./my-project
cd my-project

# Edit backend.tf:
# - Change storage_account_name to your deployed storage account
# - Change key to "my-project/terraform.tfstate"

# Create secrets file
cp secrets.auto.tfvars.example secrets.auto.tfvars
# (Add same SP credentials as storacct)

# Initialize with remote state
terraform init -reconfigure

# Deploy
terraform plan
terraform apply
```

---

### 4️⃣ Verify

```bash
# Check state file exists in Azure
az storage blob list \
  --account-name YOUR_STORAGE_ACCOUNT \
  --container-name tfstate \
  --output table

# Verify no local state
ls terraform.tfstate  # Should not exist
```

---

## 📁 File Structure You'll Create

```
├── storacct/                    # Deploy this ONCE
│   ├── main.tf
│   ├── providers.tf
│   ├── vars.tf
│   ├── terraform.tfvars         # ✏️ Customize
│   └── secrets.auto.tfvars      # ✏️ Add SP credentials
│
└── my-project/                  # Template for each project
    ├── backend.tf               # ✏️ Update storage account name
    ├── providers.tf
    ├── main.tf
    ├── vars.tf
    ├── terraform.tfvars         # ✏️ Customize
    └── secrets.auto.tfvars      # ✏️ Add SP credentials
```

---

## ⚠️ Critical: Add to .gitignore

```gitignore
secrets.auto.tfvars
*.tfstate
*.tfstate.*
.terraform/
```

---

## 🎯 Expected Results

After completing:
- ✅ Storage account exists: `sttfstatedev001xxx`
- ✅ Container exists: `tfstate`
- ✅ State file in Azure (not local)
- ✅ RBAC configured for SP
- ✅ State locking enabled automatically

---

## 🆘 Common Issues

| Error | Fix |
|-------|-----|
| "Failed to get workspaces" | Add "Storage Blob Data Contributor" RBAC |
| "Backend init required" | Run `terraform init -reconfigure` |
| "Version constraint" | Run `terraform init -upgrade` |
| "Storage account exists" | Change name in terraform.tfvars |

---

**Need more details?** See the full [README.md](README.md) and [CHECKLIST.md](CHECKLIST.md)
