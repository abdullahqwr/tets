resource "azurerm_container_registry" "this" {
  name                = var.name != "" ? var.name : "${var.prefix}acr${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  tags                = var.tags
  zone_redundancy_enabled = true
}

resource "random_id" "suffix" {
  byte_length = 3
}
