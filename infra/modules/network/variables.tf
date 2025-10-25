variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_cidr" {
  type = string
}

variable "aks_subnet_cidr" {
  type = string
}

variable "sql_subnet_cidr" {
  type = string
}

variable "app_gateway_subnet_cidr" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "prefix" {
  type    = string
  default = "aks"
}
