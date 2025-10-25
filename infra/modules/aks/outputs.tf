output "name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "kube_config" {
  value = {
    host                   = azurerm_kubernetes_cluster.this.kube_config[0].host
    cluster_ca_certificate = azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
    token                  = azurerm_kubernetes_cluster.this.kube_config[0].password
  }
  sensitive = true
}

output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}

output "kubelet_identity_id" {
  value = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}
