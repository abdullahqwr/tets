resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  default_node_pool {
    name                = "system"
    vm_size             = var.system_node_pool_vm_size
    node_count          = 2
    type                = "VirtualMachineScaleSets"
    mode                = "System"
    os_disk_size_gb     = 64
    vnet_subnet_id      = var.vnet_subnet_id
    orchestrator_version = var.kubernetes_version
    node_labels = {
      "nodepool-type" = "system"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
  }

  network_profile {
    network_plugin     = var.network_profile.network_plugin
    network_policy     = var.network_profile.network_policy
    outbound_type      = var.network_profile.outbound_type
    load_balancer_sku  = var.network_profile.load_balancer_sku
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    service_cidr       = var.service_cidr
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  azure_policy_enabled = true
  oidc_issuer_enabled  = true
  workload_identity_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  dynamic "ingress_application_gateway" {
    for_each = var.app_gateway_id != "" ? [var.app_gateway_id] : []
    content {
      gateway_id = ingress_application_gateway.value
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "usernp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.user_node_pool_vm_size
  node_count            = var.user_node_pool_min_count
  min_count             = var.user_node_pool_min_count
  max_count             = var.user_node_pool_max_count
  enable_auto_scaling   = var.enable_auto_scaler
  mode                  = "User"
  orchestrator_version  = var.kubernetes_version
  vnet_subnet_id        = var.vnet_subnet_id
  max_pods              = var.user_node_pool_max_pods
  node_labels = {
    "nodepool-type" = "user"
  }
  node_taints = [
    "workload=stateless:NoSchedule"
  ]
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
}

resource "azurerm_role_assignment" "agic_network" {
  count                = var.app_gateway_id != "" ? 1 : 0
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope                = var.app_gateway_id
}
