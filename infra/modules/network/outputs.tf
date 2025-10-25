output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "sql_subnet_id" {
  value = azurerm_subnet.sql.id
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.sql.id
}

output "private_dns_zone_name" {
  value = azurerm_private_dns_zone.sql.name
}

output "app_gateway_subnet_id" {
  value = azurerm_subnet.app_gateway.id
}
