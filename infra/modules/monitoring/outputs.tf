output "workspace_id" {
  value = local.workspace_id
}

output "workspace_name" {
  value = local.workspace_name
}

output "application_insights_connection_string" {
  value = try(azurerm_application_insights.this[0].connection_string, "")
}

output "grafana_endpoint" {
  value = var.install_kube_prometheus ? "https://${var.grafana_hostname}" : ""
}
