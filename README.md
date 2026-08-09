# Azure Landing Zone Terraform Infrastructure

This repository contains modular Infrastructure as Code (IaC) written in Terraform to provision and manage Azure Landing Zone infrastructure. It follows a multi-environment, module-driven architecture for scalable and reusable Azure deployments.

---

## 📐 Architecture & Modular Design

The repository is structured into **reusable child modules** (`Childmodule/`) and **environment-specific deployment configurations** (`Enviroment/`).

```
Landing-zone-test/
├── Childmodule/                  # Reusable Terraform Child Modules
│   ├── azurerm_rg/               # Azure Resource Groups
│   ├── azurerm_vnet/             # Azure Virtual Networks
│   ├── azurerm_subnet/           # Azure Subnets
│   ├── azurerm_pip/              # Azure Public IPs
│   ├── azurerm_keyvault/         # Azure Key Vault & Secrets
│   └── azurerm_vm/               # Azure Linux VMs & Network Interfaces
├── Enviroment/                   # Environment Deployments
│   ├── dev/                      # Development Environment Configuration
│   ├── qa/                       # QA Environment Skeleton
│   └── prod/                     # Production Environment Skeleton
├── .gitignore                    # Git Ignore rules for Terraform state & secrets
└── README.md                     # Project documentation
```

---

## 🛠️ Modules Overview

All child modules leverage Terraform `for_each` maps to dynamically provision multiple resources cleanly:

| Module | Resource Type | Description |
| :--- | :--- | :--- |
| **`azurerm_rg`** | `azurerm_resource_group` | Manages Azure Resource Groups with dynamic location and properties. |
| **`azurerm_vnet`** | `azurerm_virtual_network` | Provisions Virtual Networks with customized address spaces. |
| **`azurerm_subnet`** | `azurerm_subnet` | Creates subnets within target Virtual Networks. |
| **`azurerm_pip`** | `azurerm_public_ip` | Provisions Static/Dynamic Public IP addresses. |
| **`azurerm_keyvault`** | `azurerm_key_vault`, `azurerm_key_vault_secret` | Deploys Azure Key Vault and stores sensitive credentials securely. |
| **`azurerm_vm`** | `azurerm_linux_virtual_machine`, `azurerm_network_interface` | Provisions Linux Virtual Machines and Network Interfaces with Key Vault password retrieval. |

---

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) `>= 1.0.0`
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated (`az login`)
- Active Azure Subscription

### Deployment Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/rajahalderdl027-crypto/Landing-zone-test.git
   cd Landing-zone-test
   ```

2. **Navigate to the Target Environment**
   ```bash
   cd Enviroment/dev
   ```

3. **Provide Variables Configuration**
   Create a `terraform.tfvars` file in the environment directory (e.g. `Enviroment/dev/terraform.tfvars`) with your configuration map:
   ```hcl
   rgs = {
     rg1 = {
       name     = "rg-dev-eastus"
       location = "East US"
     }
   }

   vnets = {
     vnet1 = {
       name                = "vnet-dev-001"
       location            = "East US"
       resource_group_name = "rg-dev-eastus"
       address_space       = ["10.0.0.0/16"]
     }
   }

   subnets = {
     subnet1 = {
       name                 = "subnet-dev-001"
       resource_group_name  = "rg-dev-eastus"
       virtual_network_name = "vnet-dev-001"
       address_prefixes     = ["10.0.1.0/24"]
     }
   }

   pips = {
     pip1 = {
       name                = "pip-dev-vm-001"
       resource_group_name = "rg-dev-eastus"
       location            = "East US"
       allocation_method   = "Static"
     }
   }

   vms = {
     vm1 = {
       vm_name               = "vm-dev-001"
       nic_name              = "nic-dev-vm-001"
       ip_configuration_name = "internal"
       location              = "East US"
       resource_group_name   = "rg-dev-eastus"
       subnet_name           = "subnet-dev-001"
       virtual_network_name  = "vnet-dev-001"
       pip_name              = "pip-dev-vm-001"
       vm_size               = "Standard_B1s"
       admin_username        = "azureuser"
     }
   }
   ```

4. **Initialize Terraform**
   ```bash
   terraform init
   ```

5. **Generate Execution Plan**
   ```bash
   terraform plan -out=tfplan
   ```

6. **Apply Configuration**
   ```bash
   terraform apply tfplan
   ```

---

## 🔒 Security & Best Practices

- **Secrets Management**: Sensitive credentials like VM administrator passwords are kept in Azure Key Vault and referenced dynamically via Terraform data sources.
- **Git Hygiene**: `.tfvars` files, state files (`*.tfstate`), and transient lock files are ignored via `.gitignore` to prevent sensitive credentials or local state from leaking into source control.
- **Explicit Dependencies**: Inter-module deployment ordering is enforced via `depends_on` (Resource Group → VNet → Subnets & Public IP → Virtual Machines).

---

## 📄 License

This repository is maintained for Azure cloud infrastructure provisioning.