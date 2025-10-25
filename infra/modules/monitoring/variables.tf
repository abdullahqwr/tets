variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }
variable "create_workspace" {
  type    = bool
  default = false
}
variable "workspace_name" {
  type    = string
  default = ""
}
variable "log_analytics_workspace_id" {
  type    = string
  default = ""
}
variable "install_kube_prometheus" {
  type    = bool
  default = false
}
variable "namespace" {
  type    = string
  default = "observability"
}
variable "kube_prometheus_version" {
  type    = string
  default = "55.5.0"
}
variable "ingress_class" {
  type    = string
  default = "azure-application-gateway"
}
variable "grafana_hostname" {
  type    = string
  default = "grafana.example.com"
}
variable "enable_application_insights" {
  type    = bool
  default = true
}
variable "prefix" {
  type    = string
  default = "app"
}
