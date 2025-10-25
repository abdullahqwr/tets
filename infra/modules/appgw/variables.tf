variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "subnet_id" { type = string }
variable "tags" { type = map(string) }
variable "certificate_secret_id" {
  description = "Key Vault secret identifier containing PFX certificate"
  type        = string
}
variable "identity_id" {
  description = "User-assigned managed identity resource ID"
  type        = string
}
variable "sku_name" {
  type    = string
  default = "WAF_v2"
}
variable "sku_tier" {
  type    = string
  default = "WAF_v2"
}
variable "capacity" {
  type    = number
  default = 2
}
variable "prefix" {
  type    = string
  default = "app"
}
