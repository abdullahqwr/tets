variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "administrator_login" { type = string }
variable "administrator_password" {
  type      = string
  default   = ""
  sensitive = true
}
variable "sku_name" { type = string }
variable "db_name" { type = string }
variable "vnet_subnet_id" { type = string }
variable "private_dns_zone_name" { type = string }
variable "tags" { type = map(string) }
variable "prefix" {
  type    = string
  default = "app"
}
