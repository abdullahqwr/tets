variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "sku" { type = string }
variable "admin_enabled" { type = bool }
variable "tags" { type = map(string) }
variable "name" {
  type    = string
  default = ""
}
variable "prefix" {
  type    = string
  default = "app"
}
