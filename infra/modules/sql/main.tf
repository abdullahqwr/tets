resource "random_password" "admin" {
  length           = 20
  special          = true
  override_special = "!@#$%"
}

locals {
  admin_password = var.administrator_password != "" ? var.administrator_password : random_password.admin.result
}

resource "azurerm_mssql_server" "this" {
  name                         = "${var.prefix}-sqlsrv"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = local.admin_password
  minimum_tls_version          = "1.2"
  public_network_access_enabled = false
  tags                         = var.tags
}

resource "azurerm_mssql_database" "this" {
  name           = var.db_name
  server_id      = azurerm_mssql_server.this.id
  sku_name       = var.sku_name
  zone_redundant = true
  tags           = var.tags
}

resource "azurerm_private_endpoint" "sql" {
  name                = "${var.prefix}-sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.vnet_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "sql"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.this.id
    subresource_names              = ["sqlServer"]
  }
}

resource "azurerm_private_dns_a_record" "sql" {
  name                = azurerm_mssql_server.this.name
  zone_name           = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql.private_service_connection[0].private_ip_address]
}
