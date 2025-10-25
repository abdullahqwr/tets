resource "azurerm_public_ip" "this" {
  name                = "${var.prefix}-appgw-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_application_gateway" "this" {
  name                = "${var.prefix}-appgw"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.capacity
  }
  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.subnet_id
  }
  frontend_port {
    name = "https"
    port = 443
  }
  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.this.id
  }
  backend_address_pool {
    name = "aks-backend"
  }
  backend_http_settings {
    name                  = "https-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }
  http_listener {
    name                           = "https-listener"
    frontend_ip_configuration_name = "public"
    frontend_port_name             = "https"
    protocol                       = "Https"
    ssl_certificate_name           = "gateway-cert"
  }
  ssl_certificate {
    name            = "gateway-cert"
    key_vault_secret_id = var.certificate_secret_id
  }
  request_routing_rule {
    name                       = "aks-rule"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "aks-backend"
    backend_http_settings_name = "https-settings"
    priority                   = 100
  }
  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }
  identity {
    type = "UserAssigned"
    user_assigned_identity_ids = [var.identity_id]
  }
  tags = var.tags
}
