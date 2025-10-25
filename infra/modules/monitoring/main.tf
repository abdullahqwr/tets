resource "random_string" "grafana_admin" {
  length  = 16
  special = false
}

locals {
  workspace_name = var.workspace_name != "" ? var.workspace_name : "${var.prefix}-law"
  grafana_domain = var.grafana_hostname
}

resource "azurerm_log_analytics_workspace" "this" {
  count               = var.create_workspace ? 1 : 0
  name                = local.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 5
  tags                = var.tags
}

resource "azurerm_application_insights" "this" {
  count               = var.enable_application_insights ? 1 : 0
  name                = "${var.prefix}-appi"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = var.create_workspace ? azurerm_log_analytics_workspace.this[0].id : var.log_analytics_workspace_id
  tags                = var.tags
}

locals {
  workspace_id = var.create_workspace ? azurerm_log_analytics_workspace.this[0].id : var.log_analytics_workspace_id
}

resource "kubernetes_namespace" "observability" {
  count = var.install_kube_prometheus ? 1 : 0
  metadata {
    name = var.namespace
    labels = {
      "istio-injection" = "disabled"
    }
  }
}

resource "helm_release" "kube_prometheus" {
  count      = var.install_kube_prometheus ? 1 : 0
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.namespace
  version    = var.kube_prometheus_version
  timeout    = 600
  create_namespace = false

  values = [
    yamlencode({
      grafana = {
        adminPassword = random_string.grafana_admin.result
        ingress = {
          enabled = true
          ingressClassName = var.ingress_class
          hosts = [local.grafana_domain]
          tls = [
            {
              secretName = "grafana-tls"
              hosts      = [local.grafana_domain]
            }
          ]
        }
        sidecar = {
          dashboards = { enabled = true }
          datasources = { enabled = true }
        }
      }
      prometheus = {
        prometheusSpec = {
          retention = "15d"
          scrapeInterval = "30s"
        }
      }
      alertmanager = {
        alertmanagerSpec = {
          replicas = 2
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.observability]
}
