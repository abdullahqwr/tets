variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tenant_id" { type = string }
variable "sku_name" { type = string }
variable "aks_managed_identity_id" { type = string }
variable "github_oidc_object_id" { type = string }
variable "purge_protection_enabled" { type = bool }
variable "soft_delete_retention_days" { type = number }
variable "tags" { type = map(string) }
variable "prefix" {
  type    = string
  default = "app"
}
variable "additional_secret_reader_object_ids" {
  type    = list(string)
  default = []
}
