variable "backend_resource_group_name" {
  description = "Resource group for Terraform backend storage account"
  type        = string
}

variable "backend_storage_account_name" {
  description = "Storage account for Terraform state"
  type        = string
}

variable "backend_container_name" {
  description = "Storage container for Terraform state"
  type        = string
}

variable "backend_state_key" {
  description = "Blob name for Terraform state file"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for AKS resources"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Common tag map"
  type        = map(string)
  default = {
    environment = "prod"
    owner       = "platform"
  }
}

variable "vnet_cidr" {
  description = "CIDR block for the AKS virtual network"
  type        = string
}

variable "aks_subnet_cidr" {
  description = "CIDR block for AKS subnet"
  type        = string
}

variable "sql_subnet_cidr" {
  description = "CIDR block for SQL private endpoint subnet"
  type        = string
}

variable "app_gateway_subnet_cidr" {
  description = "CIDR block for Application Gateway subnet"
  type        = string
}

variable "acr_sku" {
  description = "Azure Container Registry SKU"
  type        = string
  default     = "Premium"
}

variable "aks_dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "aks_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28.5"
}

variable "aks_network_profile" {
  description = "Network profile configuration for AKS"
  type = object({
    network_plugin    = string
    network_policy    = string
    outbound_type     = string
    load_balancer_sku = string
  })
  default = {
    network_plugin    = "azure"
    network_policy    = "azure"
    outbound_type     = "userDefinedRouting"
    load_balancer_sku = "standard"
  }
}

variable "system_node_pool_vm_size" {
  description = "VM size for system node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "user_node_pool_vm_size" {
  description = "VM size for user node pool"
  type        = string
  default     = "Standard_DS3_v2"
}

variable "user_node_pool_min_count" {
  description = "Minimum node count for user node pool"
  type        = number
  default     = 3
}

variable "user_node_pool_max_count" {
  description = "Maximum node count for user node pool"
  type        = number
  default     = 10
}

variable "user_node_pool_max_pods" {
  description = "Maximum pods per node"
  type        = number
  default     = 30
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "github_oidc_object_id" {
  description = "Object ID of GitHub Actions federated credential"
  type        = string
}

variable "key_vault_sku" {
  description = "Key Vault SKU"
  type        = string
  default     = "standard"
}

variable "sql_admin_login" {
  description = "SQL administrator username"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL administrator password"
  type        = string
  sensitive   = true
}

variable "sql_sku_name" {
  description = "SKU for Azure SQL Database"
  type        = string
  default     = "GP_Gen5_2"
}

variable "sql_db_name" {
  description = "Name of the Azure SQL Database"
  type        = string
}

variable "grafana_hostname" {
  description = "Public hostname for Grafana ingress"
  type        = string
  default     = "grafana.example.com"
}

variable "app_gateway_certificate_secret_id" {
  description = "Azure Key Vault secret ID containing the Application Gateway TLS certificate"
  type        = string
}
