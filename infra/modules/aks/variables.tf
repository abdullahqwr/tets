variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "dns_prefix" { type = string }
variable "kubernetes_version" { type = string }
variable "system_node_pool_vm_size" { type = string }
variable "user_node_pool_vm_size" { type = string }
variable "user_node_pool_min_count" { type = number }
variable "user_node_pool_max_count" { type = number }
variable "user_node_pool_max_pods" { type = number }
variable "enable_auto_scaler" { type = bool }
variable "vnet_subnet_id" { type = string }
variable "network_profile" {
  type = object({
    network_plugin    = string
    network_policy    = string
    outbound_type     = string
    load_balancer_sku = string
  })
}
variable "log_analytics_workspace_id" { type = string }
variable "acr_id" { type = string }
variable "tags" { type = map(string) }
variable "prefix" {
  type    = string
  default = "app"
}
variable "app_gateway_id" {
  type    = string
  default = ""
}
variable "dns_service_ip" {
  type    = string
  default = "10.0.0.10"
}
variable "service_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "docker_bridge_cidr" {
  type    = string
  default = "172.17.0.1/16"
}
