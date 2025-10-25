output "aks_name" {
  value       = module.aks.name
  description = "Name of the AKS cluster"
}

output "resource_group_name" {
  value       = azurerm_resource_group.core.name
  description = "Primary resource group name"
}

output "sql_private_endpoint_ip" {
  value       = module.sql.private_endpoint_ip
  description = "Private IP address for the SQL Database endpoint"
}

output "grafana_endpoint" {
  value       = module.observability.grafana_endpoint
  description = "Grafana ingress endpoint"
}

output "application_gateway_public_ip" {
  value       = module.app_gateway.frontend_ip_address
  description = "Public IP address of the Application Gateway"
}
