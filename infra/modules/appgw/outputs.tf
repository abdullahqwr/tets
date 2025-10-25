output "id" {
  value = azurerm_application_gateway.this.id
}

output "frontend_ip_address" {
  value = azurerm_public_ip.this.ip_address
}

output "backend_address_pool_id" {
  value = azurerm_application_gateway.this.backend_address_pool[0].id
}

