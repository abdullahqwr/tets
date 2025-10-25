terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.97"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }

  backend "azurerm" {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = var.backend_state_key
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = module.aks.kube_config.host
  cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
  token                  = module.aks.kube_config.token
}

provider "helm" {
  kubernetes {
    host                   = module.aks.kube_config.host
    cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
    token                  = module.aks.kube_config.token
  }
}

resource "azurerm_resource_group" "core" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_user_assigned_identity" "app_gateway" {
  name                = "${var.resource_group_name}-appgw-identity"
  resource_group_name = azurerm_resource_group.core.name
  location            = var.location
  tags                = var.tags
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.core.name
  location            = var.location
  vnet_cidr           = var.vnet_cidr
  aks_subnet_cidr     = var.aks_subnet_cidr
  sql_subnet_cidr     = var.sql_subnet_cidr
  app_gateway_subnet_cidr = var.app_gateway_subnet_cidr
  tags                = var.tags
}

module "log_analytics" {
  source              = "./modules/monitoring"
  resource_group_name = azurerm_resource_group.core.name
  location            = var.location
  tags                = var.tags
  create_workspace    = true
}

module "acr" {
  source              = "./modules/acr"
  resource_group_name = azurerm_resource_group.core.name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = false
  tags                = var.tags
}

module "app_gateway" {
  source                = "./modules/appgw"
  resource_group_name   = azurerm_resource_group.core.name
  location              = var.location
  subnet_id             = module.network.app_gateway_subnet_id
  tags                  = var.tags
  certificate_secret_id = var.app_gateway_certificate_secret_id
  identity_id           = azurerm_user_assigned_identity.app_gateway.id
  depends_on            = [module.key_vault]
}

module "aks" {
  source                       = "./modules/aks"
  resource_group_name          = azurerm_resource_group.core.name
  location                     = var.location
  dns_prefix                   = var.aks_dns_prefix
  kubernetes_version           = var.aks_version
  network_profile              = var.aks_network_profile
  vnet_subnet_id               = module.network.aks_subnet_id
  enable_auto_scaler           = true
  system_node_pool_vm_size     = var.system_node_pool_vm_size
  user_node_pool_vm_size       = var.user_node_pool_vm_size
  user_node_pool_max_count     = var.user_node_pool_max_count
  user_node_pool_min_count     = var.user_node_pool_min_count
  user_node_pool_max_pods      = var.user_node_pool_max_pods
  acr_id                       = module.acr.id
  log_analytics_workspace_id   = module.log_analytics.workspace_id
  app_gateway_id               = module.app_gateway.id
  tags                         = var.tags
}

module "key_vault" {
  source                        = "./modules/keyvault"
  resource_group_name           = azurerm_resource_group.core.name
  location                      = var.location
  tenant_id                     = var.tenant_id
  sku_name                      = var.key_vault_sku
  aks_managed_identity_id       = module.aks.kubelet_identity_id
  github_oidc_object_id         = var.github_oidc_object_id
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90
  tags                          = var.tags
  additional_secret_reader_object_ids = [azurerm_user_assigned_identity.app_gateway.principal_id]
}

module "sql" {
  source                        = "./modules/sql"
  resource_group_name           = azurerm_resource_group.core.name
  location                      = var.location
  administrator_login           = var.sql_admin_login
  administrator_password        = var.sql_admin_password
  sku_name                      = var.sql_sku_name
  db_name                       = var.sql_db_name
  vnet_subnet_id                = module.network.sql_subnet_id
  private_dns_zone_name         = module.network.private_dns_zone_name
  tags                          = var.tags
}

module "observability" {
  source                      = "./modules/monitoring"
  resource_group_name         = azurerm_resource_group.core.name
  location                    = var.location
  tags                        = var.tags
  create_workspace            = false
  log_analytics_workspace_id  = module.log_analytics.workspace_id
  install_kube_prometheus     = true
  grafana_hostname            = var.grafana_hostname
}

output "aks_kubeconfig" {
  description = "Kubeconfig for the AKS cluster"
  value       = module.aks.kube_config_raw
  sensitive   = true
}

output "acr_login_server" {
  description = "The login server URL for the Azure Container Registry"
  value       = module.acr.login_server
}

output "key_vault_id" {
  description = "Key Vault resource ID"
  value       = module.key_vault.id
}
